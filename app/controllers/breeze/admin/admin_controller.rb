module Breeze
  module Admin
    class AdminController < Breeze::Controller
      before_filter :authenticate_admin!
      around_filter :set_current_user

      layout :determine_layout
      
      helper AdminHelper, LayoutsHelper, ThemesHelper, PagesHelper,
        AssetsHelper
      helper_method :current_user, :signed_in?
    
      def current_user
        current_admin
      end

      def signed_in?
        admin_signed_in?
      end

    protected
    
      def determine_layout
        request.xhr? ? false : "admin"
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

      def write_file(path, content)
        content = content.force_encoding("utf-8") if content.respond_to?(:force_encoding)
        File.open(path, "w") do |f|
          f.write content
        end
      end
    end
  end
end
