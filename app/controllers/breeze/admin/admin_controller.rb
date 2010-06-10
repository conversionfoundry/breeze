module Breeze
  module Admin
    class AdminController < Breeze::Controller
      unloadable
      
      before_filter :authenticate_admin!
      around_filter :set_current_user

      layout :determine_layout
      
      helper AdminHelper, LayoutsHelper, ThemesHelper, PagesHelper
      helper_method :current_user, :signed_in?
      
    protected
      alias_method :current_user, :current_admin
      alias_method :signed_in?, :admin_signed_in?
    
      def determine_layout
        request.xhr? ? false : "breeze"
      end
      
      def after_sign_in_path_for(resource)
        if resource.is_a?(User)
          admin_root_path
        else
          super
        end
      end
      
      def after_sign_out_path_for(resource)
        if resource.is_a?(User)
          admin_root_path
        else
          super
        end
      end
      
      def current_ability
        current_user.ability
      end
      
      def set_current_user(&block)
        User.with_user current_user, &block
      end
    end
  end
end