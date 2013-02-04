module Breeze
  module Admin
    class SettingsController < AdminController
      def show
        @robots_txt = File.read(Rails.root.to_s + '/public/robots.txt')
        render :action => "edit"
      end
      
      def edit
        @robots_txt = File.read(Rails.root.to_s + '/public/robots.txt')
      end
      
      def update
        Breeze.config.update_attributes params[:settings]

        @robots_txt = (params[:robots_txt] ? params[:robots_txt][:contents] : nil) || ""
        if write_file(Rails.root.to_s + '/public/robots.txt', @robots_txt)
          flash[:notice] = "Settings updated"
        end
      end
      
      def current_time
        Time.zone = params[:zone] if params[:zone].present?
        render :partial => "current_time"
      end
    end
  end
end