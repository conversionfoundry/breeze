module Breeze
  module Content
    module Mixins
      module Permalinks


        def self.included(base)
          base.field :permalink
          base.field :slug

          base.attr_protected :_id

          base.before_validation :fill_in_slug
          base.before_validation :regenerate_permalink
          base.after_save :update_child_permalinks

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
        
        # When a permalink changes, permalinks for child pages also need to be updated
        def update_child_permalinks
          if respond_to?(:children) && permalink_changed?
            self.children.each do |child|
              child.permalink = PermalinkGenerator.new(child).allocate
              child.save!
            end
          end
        end

        def redirects
          Breeze::Content::Redirect.where(:targetlink => permalink)
        end

      protected

        def fill_in_slug
          self.slug = SlugGenerator.new(self).allocate
        end

        def regenerate_permalink
          self.permalink = PermalinkGenerator.new(self).allocate
        end

        class PermalinkGenerator < Struct.new(:tree_node)
          def allocate
            tree_node.root? ? "/" : generate
          end

          def generate
            "".tap do |permalink|
              permalink.prepend("/#{tree_node.slug}")
              permalink.prepend(PermalinkGenerator.new(tree_node.parent).generate) unless tree_node.parent.try(:root?)
            end
          end

        private
          def permalink_taken?(permalink)
            Breeze::Content::Item.where(permalink: permalink).exists?
          end
        end
        
        class SlugGenerator < Struct.new(:tree_node)
          def allocate
            default_slug = tree_node.slug || tree_node.title.parameterize.gsub(/(^[\-]+|[-]+$)/, "") if tree_node.title
            taken_slugs = Breeze::Content::Item.where(slug: /.*#{default_slug}.*/i, parent_id: tree_node.parent_id).map(&:slug)
            if taken_slugs.any? && taken_slugs.include?(default_slug) && ( tree_node.new_record? || (tree_node.persisted? && tree_node.slug_changed?) )
              generate(default_slug, *taken_slugs)
            else
              default_slug
            end
          end

          def generate(default_slug, *taken_slugs)
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
end
