module Breeze
  module Content
    class Page < NavigationItem
      include Mixins::Container
      
      def variables_for_render
        super.merge :page => self
      end
      
      def editable?
        true
      end
      
      def view_for(controller, request)
        if controller.admin_signed_in? && request.params[:view]
          views.by_name request.params[:view]
        else  
          views.default
        end
      end
            
      def self.[](permalink)
        where(:permalink => permalink).first
      end
    end
  end
end