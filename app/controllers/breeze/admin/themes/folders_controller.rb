module Breeze
  module Admin
    module Themes
      class FoldersController < Breeze::Admin::AdminController
        def edit
          @path = "/" + Array(params[:id]).join("/").gsub("+", " ")
          if request.put?
            if params[:folder].try(:key?, :name) && !system_folder?(@path)
              @new_path = File.join(File.dirname(@path), params[:folder][:name])
              FileUtils.mv File.join(theme.path, @path), File.join(theme.path, @new_path)
            end
            if params[:folder] && params[:folder][:name]
              @old_path = @path
              @path = File.join File.dirname(@old_path), params[:folder][:name]
              begin
                FileUtils.mv theme.file(@old_path), theme.file(@path)
              rescue
              end
              render :action => :move
            else
              render :action => :update
            end
          elsif request.delete?
            FileUtils.rm_r theme.file(@path) unless system_folder?(@path)
            render :action => :destroy
          elsif request.post?
            @new_folder = File.join @path, params[:folder][:name]
            FileUtils.mkdir_p File.join(theme.path, @new_folder)
            @path = @new_folder
          else

          end
        end
        
      protected
        def theme
          @theme ||= Breeze::Theming::Theme[params[:theme_id]]
        end
        helper_method :theme
        
        def system_folder?(path)
          %w(images layouts stylesheets javascripts).include?(path.sub(/^\//, ''))
        end
        helper_method :system_folder?
        
        def form_action
          "/admin/themes/#{theme.name}/folders#{@path}"
        end
        helper_method :form_action
      end
    end
  end
end