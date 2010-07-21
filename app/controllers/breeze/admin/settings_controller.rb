module Breeze
  module Admin
    class SettingsController < AdminController
      unloadable
      
      def show
        render :action => "edit"
      end
      
      def edit
      end
      
      def update
        Breeze.config.update_attributes params[:settings]
        flash[:notice] = "Settings updated"
        redirect_to admin_settings_path
      end
      
      def current_time
        Time.zone = params[:zone] if params[:zone].present?
        render :partial => "current_time"
      end
    end
  end
end