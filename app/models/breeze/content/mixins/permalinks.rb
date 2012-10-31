module Breeze
  module Content
    module Mixins
      module Permalinks

        class Generator < Struct.new(:tree_node)
          def generate_permalink
            c1 = tree_node.permalink.blank?
            c2 = tree_node.slug_changed?
            c3 = tree_node.respond_to?(:parent_id) && tree_node.parent_id_changed?
            if c1 || c2 || c3
              regenerate_permalink!
            else
              tree_node.permalink
            end
          end

          def regenerate_permalink!
            "/".tap do |permalink|
              if tree_node.parent_id.present?
                permalink.concat(tree_node.slug.to_s) 
                permalink.prepend(Generator.new(tree_node.parent).regenerate_permalink!) if parent_permalink_prependable?
              end
            end
          end
          
        private
          def parent_permalink_prependable?
            tree_node.respond_to?(:parent) && tree_node.parent.present? && tree_node.parent.permalink.to_s != "/"
          end
        end


        def self.included(base)
          base.field :permalink
          base.field :slug

          base.attr_protected :_id
          base.after_save :update_child_permalinks

          base.before_validation :fill_in_slug
          base.before_validation :regenerate_permalink

          base.validates_format_of :permalink, :with => /^(\/|(\/[\w\-]+)+)$/, :message => "must contain only letters, numbers, underscores or dashes"
          base.validates_uniqueness_of :permalink 
          base.validates :slug, uniqueness: { scope: :parent_id }
          base.index({ permalink: 1 }, { unique: true })
          
          base.class_eval do
            def permalink(include_domain = false)
              if include_domain
                "#{Breeze.domain}#{read_attribute(:permalink)}"
              else
                read_attribute(:permalink)
              end
            end
          end
        end

        def regenerate_permalink
          self.permalink = Generator.new(self).generate_permalink
        end

        
        # When a permalink changes, permalinks for child pages also need to be updated
        def update_child_permalinks
          if respond_to?(:children)
            self.children.each do |child|
              child.permalink = Generator.new(child).regenerate_permalink!
              child.save!
            end
          end
        end

        def redirects
          Breeze::Content::Redirect.where(:targetlink => permalink)
        end

      protected

        def fill_in_slug
          default_slug = title.parameterize.gsub(/(^[\-]+|[-]+$)/, "")
          taken_slugs = Breeze::Content::Item.where(slug: /.*#{default_slug}.*/i, parent_id: parent_id).map(&:slug)
          if taken_slugs.any? && taken_slugs.include?(default_slug) && self.slug_changed?
            self.slug = generate_slug(default_slug, *taken_slugs)
          else
            self.slug ||= default_slug
          end
          self
        end

        def generate_slug(default_slug, *taken_slugs)
          result = nil
          taken_slugs.each_with_index do |slug, i|
            this_one = '%s-%s' % [default_slug, i+2]
            result ||= this_one unless taken_slugs.include? this_one
          end
          result ||= '%s-%s' % [default_slug, taken_slugs.count + 2] # if it is still not filled
        end
      end
    end
  end
end
