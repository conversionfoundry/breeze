module Breeze
  module Content
    module Mixins
      module Permalinks
        def self.included(base)
          base.field :permalink
          base.field :slug

          base.before_validate :fill_in_slug_and_permalink
          base.validates_format_of :permalink, :with => /^(\/|(\/[\w\-]+)+)$/, :message => "must contain only letters, numbers, underscores or dashes"
          base.validates_uniqueness_of :permalink
          base.index :permalink
        end
        
        def level
          permalink.count("/")
        end
        
      protected
        def fill_in_slug_and_permalink
          self.slug = self.title.parameterize.gsub(/(^[\-]+|[-]+$)/, "") if self.slug.blank? && respond_to?(:title) && !self.title.blank?
          regenerate_permalink
        end
        
        def regenerate_permalink
          regenerate_permalink! if permalink.blank? || slug_changed? || (respond_to?(:parent_id) && parent_id_changed?)
        end
        
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
      end
    end
  end
end