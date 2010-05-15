module Breeze
  module Content
    class NavigationItem < Item
      include Mongoid::Document
      include Mixins::TreeStructure
      include Mixins::Permalinks
      
      field :title
      field :subtitle
      field :show_in_navigation, :type => Boolean, :default => true
    end
  end
end