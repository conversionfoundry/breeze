module Breeze
  module Content
    module Mixins
      module Permalinks
        def self.included(base)
          base.field :permalink
          base.field :slug
          base.index :permalink, :unique => true
          
          base.validates_uniqueness_of :permalink
          base.validates_uniqueness_of :slug, :scope => :parent_id if base.fields[:parent_id].present?
          
          base.before_create :fill_in_slug_and_permalink
        end
        
        module ClassMethods
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
          self.permalink = if respond_to?(:parent) && !parent.nil?
            File.join(parent.permalink, slug)
          else
            "/#{slug}"
          end
        end
        
        def root_in_tree?
          respond_to?(:root?) && root?
        end
      end
    end
  end
end