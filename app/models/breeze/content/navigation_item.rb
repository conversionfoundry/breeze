module Breeze
  module Content
    class NavigationItem < Item
      include Mongoid::Document
      
      field :title
      field :subtitle
      field :show_in_navigation, :type => Boolean, :default => true
      include Mixins::TreeStructure
      include Mixins::Permalinks
      
      validates_presence_of :title
      
      def editable?
        false
      end
      
      def duplicate(attrs = {})
        new_slug, i = slug, 2
        while Breeze::Content::Item.where(:slug => new_slug, :parent_id => attrs[:parent_id] || parent_id).count > 0
          new_slug, i = "#{slug}-#{i}", i + 1
        end
        returning super(attrs.merge(:slug => new_slug, :position => position + 1)) do |new_item|
          unless children.empty?
            children.each { |child| child.duplicate(:parent_id => new_item.id) }
          end
        end
      end
    end
  end
end