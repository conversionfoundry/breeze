module Breeze
  module Content
    module Mixins
      module Permalinks
        def self.included(base)
          base.attr_accessible :permalink, :slug
          base.field :permalink
          base.field :slug

          base.before_validation :fill_in_slug_and_permalink
          base.after_save :update_child_permalinks
          base.validates_format_of :permalink, :with => /^(\/|(\/[\w\-]+)+)$/, :message => "must contain only letters, numbers, underscores or dashes"
          base.validates_uniqueness_of :permalink
          base.index({ :permalink => 1 })
          
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
        
        # TODO: This should be in TreeStructure
        # def level
        #   permalink.count("/")
        # end

        # def validate_uniqueness_of_permalink?
        #   true
        # end

        def regenerate_permalink!
          
          self.permalink = if respond_to?(:parent)
            if parent.nil?
              "/"
            else
              File.join(parent.permalink, slug)
            end
          else
            "/#{slug}"
          end
                    
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
        def fill_in_slug_and_permalink
          self.slug = self.title.parameterize.gsub(/(^[\-]+|[-]+$)/, "") if self.slug.blank? && respond_to?(:title) && !self.title.blank?
          regenerate_permalink
        end
        
        def regenerate_permalink
          regenerate_permalink! if permalink.blank? || slug_changed? || (respond_to?(:parent_id) && parent_id_changed?)
        end
        
      end
    end
  end
end
