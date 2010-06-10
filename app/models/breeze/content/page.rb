module Breeze
  module Content
    class Page < NavigationItem
      include Mixins::Container
      
      after_create  { |page| Breeze::Admin::Activity.log :create, page }
      after_update  { |page| Breeze::Admin::Activity.log :update, page }
      before_destroy { |page| Breeze::Admin::Activity.log :delete, page }
      
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