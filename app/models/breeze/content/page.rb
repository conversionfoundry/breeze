module Breeze
  module Content
    class Page < NavigationItem
      include Mixins::Container
      
      def variables_for_render
        super.merge :page => self
      end
    end
  end
end