module Breeze
  module Content
    module Mixins
      module Permalinks
        def self.included(base)
          base.field :permalink
          base.field :slug
          base.index :permalink, :unique => true
        end
        
        module ClassMethods
        end
      end
    end
  end
end