module Breeze
  module Admin
    class ThemesController < AdminController
      def index
        
      end
      
      def enable
        @theme = theme.enable!
        respond_to do |format|
          format.html { redirect_to admin_themes_path }
          format.js
        end
      end
      
      def disable
        @theme = theme.disable!
        respond_to do |format|
          format.html { redirect_to admin_themes_path }
          format.js { render :action => :enable }
        end
      end
      
    protected
      def theme
        @theme ||= Breeze::Theming::Theme[params[:id]]
      end
      helper_method :theme
    end
  end
end