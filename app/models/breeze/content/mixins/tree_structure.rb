module Breeze
  module Content
    module Mixins
      module TreeStructure
        def self.included(base)
          base.belongs_to :parent, :class_name => base.name
          base.has_many :children, :class_name => base.name, :foreign_key => :parent_id
          base.field :position, :type => Integer
          
          base.before_create :set_position
          base.before_destroy :destroy_children
          base.after_destroy :set_sibling_positions
          
          base.class_eval do
            scope :root, where(:parent_id => nil)
          end
        end
        
        def root?
          parent_id.nil?
        end
        
        def scope
          base_class.criteria.where :parent_id => parent_id
        end
        
        def self_and_siblings
          scope.order_by([[ :position, :asc ]])
        end
        
        def siblings
          self_and_siblings.where :id.ne => id
        end
        
        def previous
          scope.where(:position.lt => position).order_by([[ :position, :desc ]]).first
        end
        
        def next
          scope.where(:position.gt => position).order_by([[ :position, :asc ]]).first
        end
        
        def move!(move_type, ref_id)
          send :"move_#{move_type}!", ref_id
        end
        
        def self_and_ancestors
          [ self ].tap do |list|
            list.insert(0, *parent.self_and_ancestors) unless root?
          end
        end
        
        module ClassMethods
          
        end
        
      protected
        def set_position
          self.position ||= scope.count
          update_sibling_positions 1, self.position - 1
        end
        
        def destroy_children
          children.map(&:destroy)
        end
        
        def set_sibling_positions
          update_sibling_positions(-1)
        end
        
        def update_sibling_positions(by = 1, ref_position = nil)
          ref_position ||= position
          raise "FIX THIS FUTUR ALBAN - from past alban"
          base_class.collection.update_all(
            { :parent_id => parent_id, :position => { '$gt' => ref_position } },
            { '$inc' => { :position => by } },
            :multi => true
          )
        end
        
        def move_before!(ref_id)
          update_sibling_positions(-1)
          ref_node = base_class.find ref_id
          self.parent_id = ref_node.parent_id
          self.position = ref_node.position
          update_sibling_positions 1, ref_node.position - 1
          save
        end
        
        def move_after!(ref_id)
          update_sibling_positions(-1)
          ref_node = base_class.find ref_id
          self.parent_id = ref_node.parent_id
          self.position = ref_node.position + 1
          update_sibling_positions 1, ref_node.position
          save
        end
        
        def move_inside!(ref_id)
          self.parent_id = ref_id
          self.position = base_class.criteria.where(:parent_id => ref_id).count
          save
        end
      end
    end
  end
end
