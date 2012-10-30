module Breeze
  module Content
    module Mixins
      module Permalinks
        def self.included(base)
          base.field :permalink
          base.field :slug

          base.attr_accessible :permalink, :slug
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
        def regenerate_permalink!
          self.permalink =  "/" + slug.to_s
          self.permalink.prepend(parent_permalink) if parent_permalink_prependable?
        end
        
        # When a permalink changes, permalinks for child pages also need to be updated
        def update_child_permalinks
          if respond_to?(:children)
            self.children.each do |child|
              child.regenerate_permalink!
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
          if taken_slugs.any? && taken_slugs.include?(default_slug)
            self.slug = generate_slug(default_slug, *taken_slugs)
          else
            self.slug = default_slug
          end
          self
        end
        
        def regenerate_permalink
          regenerate_permalink! if permalink.blank? || slug_changed? || (respond_to?(:parent_id) && parent_id_changed?)
        end

        def generate_slug(default_slug, *taken_slugs)
          result = nil
          taken_slugs.each_with_index do |slug, i|
            this_one = '%s-%s' % [default_slug, i+2]
            result ||= this_one unless taken_slugs.include? this_one
          end
          result ||= '%s-%s' % [default_slug, taken_slugs.count + 2] # if it is still not filled
        end

        def parent_permalink
          if parent_permalink_prependable?
            parent.permalink
          end
        end

      private

        def parent_permalink_prependable?
          respond_to?(:parent) && parent.present? && parent.permalink.to_s != "/"
        end

      end
    end
  end
end
