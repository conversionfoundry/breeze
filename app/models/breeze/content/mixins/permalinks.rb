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
        end
        
        module ClassMethods
        end
      end
    end
  end
end