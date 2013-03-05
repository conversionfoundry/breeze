module Breeze
  module Content
    module Mixins
      module TreeStructure
        extend ActiveSupport::Concern

        included do
          belongs_to :parent, :class_name => "Breeze::Content::Page", :index => true
          has_many :children, :class_name => "Breeze::Content::Page", :foreign_key => :parent_id

          field :position, type: Integer, default: 0
          validates :position, 
            presence: true, 
            numericality: { greater_or_equal_than: 0 }, 
            uniqueness: { scope: :parent_id }
          index({ parent_id: 1, position: 1}, { unique: true })
          
          before_validation :set_position
          before_destroy :destroy_children
          after_destroy :update_sibling_positions

          scope :root, where(:parent_id => nil)
        end

        module ClassMethods
        end
        
        def root?
          parent_id.nil?
        end
        
        def first_children
          children.first
        end

        def self_and_siblings
          self.class.where(parent_id: parent_id).order_by([[ :position, :asc ]])
        end
        
        def self_and_ancestors
          ([] << self).tap do |list|
            list.unshift(*parent.self_and_ancestors) unless root?
          end
        end

        def siblings
          self_and_siblings.where :id.ne => id
        end
        
        def previous
          self.class.where(:parent_id => parent_id, :position.lt => position).order_by([[ :position, :desc ]]).first
        end
        
        def next
          self.class.where(:parent_id => parent_id, :position.gt => position).order_by([[ :position, :asc ]]).first
        end
        
        def move!(move_type, ref_id)
          node = self.class.find(ref_id)
          send :"move_#{move_type}!", node 
          node.reload
        end
        
        # Level in the page hierarchy
        # We make a special case for the root (i.e. home page), which is at level one, not zero.
        def level
          root? ? 1 : self_and_ancestors.count - 1
        end
        
     private 

        def set_position
          if self.position == 0 && ( self.position_changed? || self.parent_id_changed? )
            self.position = self_and_siblings.count
          end
          update_sibling_positions 1, self.position
        end
        
        def destroy_children
          children.map(&:destroy)
        end
        
        def update_sibling_positions(by = 1, ref_position = position)
          self.class.where(:parent_id => parent_id, :position => { '$gte' => ref_position }).inc(:position, by)
        end

        def move_before!(node)
          self.parent_id = node.parent_id
          self.position = node.position 
          update_sibling_positions(1, node.position + 1)
          save
        end
        
        def move_after!(node)
          self.parent_id = node.parent_id
          self.position = node.position + 1
          update_sibling_positions node.next.position if node.next
          save
        end
        
        def move_inside!(node)
          self.parent_id = node.id
          self.position = self.class.where(:parent_id => node.id).count
          save
        end
      end
    end
  end
end
