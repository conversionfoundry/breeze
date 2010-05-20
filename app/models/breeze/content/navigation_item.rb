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
    end
  end
end