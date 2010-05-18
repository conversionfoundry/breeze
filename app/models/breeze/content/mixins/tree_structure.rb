module Breeze
  module Content
    module Mixins
      module TreeStructure
        def self.included(base)
          base.belongs_to_related :parent, :class_name => base.name
          base.has_many_related :children, :class_name => base.name, :foreign_key => :parent_id
          base.field :position, :type => Integer, :default => 0
          
          base.named_scope :root, :conditions => { :parent_id => nil }
          
          base.before_create :set_position
          base.after_destroy :set_sibling_positions
        end
        
        def root?
          parent_id.nil?
        end
        
        def scope
          base_class.criteria.where(:parent_id => parent_id)
        end
        
        def previous
          scope.where(:position.lt => position).order_by([[ :position, :desc ]]).first
        end
        
        def next
          scope.where(:position.gt => position).order_by([[ :position, :asc ]]).first
        end
        
        module ClassMethods
          
        end
        
      protected
        def set_position
          self.position = scope.count
        end
        
        def set_sibling_positions
          base_class.collection.update(
            { :parent_id => parent_id, :position => { '$gt' => position } },
            { '$inc' => { :position => -1 } }
          )
        end
      end
    end
  end
end