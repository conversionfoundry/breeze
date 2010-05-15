module Breeze
  module Content
    module Mixins
      module TreeStructure
        def self.included(base)
          base.belongs_to_related :parent
          base.has_many_related :children, :class_name => base.name, :foreign_key => :parent_id
          base.field :position, :type => Integer, :default => 0
          
          base.named_scope :root, :conditions => { :parent_id => nil }
        end
        
        def root?
          parent_id.nil?
        end
        
        module ClassMethods
        end
      end
    end
  end
end