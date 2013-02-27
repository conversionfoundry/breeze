module Breeze
  module Content
    module Mixins
      module TreeStructure
        def self.included(base)
          base.belongs_to :parent, :class_name => base.name, :index => true
          base.has_many :children, :class_name => base.name, :foreign_key => :parent_id

          base.field :position, :type => Integer, default: 0
          base.validates :position, presence: true, numericality: { greater_or_equal_than: 0 }, uniqueness: { scope: :parent_id }
          base.index({ parent_id: 1, position: 1}, { unique: true })
          
          base.attr_protected :_id
          
          base.before_validation :set_position
          base.before_destroy :destroy_children
          base.after_destroy :update_sibling_positions
          
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
        
        def first_children
          base_class.where(parent_id: id).first
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
          # node = base_class.criteria.where(:parent_id => ref_id).first
          node = base_class.criteria.find(ref_id)
          send :"move_#{move_type}!", node 
          node.reload
        end
        
        def self_and_ancestors
          ([] << self).tap do |list|
            list.unshift(*parent.self_and_ancestors) unless root?
          end
        end

        # Level in the page hierarchy
        # We make a special case for the root (i.e. home page), which is at level one, not zero.
        def level
          if root?
            1
          else
            self_and_ancestors.count - 1
          end
        end
        
        module ClassMethods
        end
        
      protected

        def set_position
          self.position = scope.count if ( self.position == 0 && ( self.position_changed? || self.parent_id_changed? ) )
          update_sibling_positions
        end
        
        def destroy_children
          children.map(&:destroy)
        end
        
        def update_sibling_positions(ref_position=self.position)
          siblings.where(:parent_id => parent_id, :position => { '$gte' => ref_position }).inc(:position, 1)
        end
        
        def move_before!(target)
          self.parent_id = target.parent_id
          self.position = target.position 
          save
        end
        
        def move_after!(target)
          self.parent_id = target.parent_id
          self.position = target.position + 1
          update_sibling_positions target.next.position if target.next
          save
        end
        
        def move_inside!(target)
          self.parent_id = target.id
          self.position = base_class.criteria.where(:parent_id => target.id).count
          save
        end
      end
    end
  end
end
