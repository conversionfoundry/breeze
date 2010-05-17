module Breeze
  module Admin
    class AdminController < ApplicationController
      before_filter :authenticate_admin!
      
      layout :determine_layout
      
      helper AdminHelper, LayoutsHelper, ThemesHelper
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
    end
  end
end