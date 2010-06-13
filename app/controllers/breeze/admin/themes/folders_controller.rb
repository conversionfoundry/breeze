module Breeze
  module Admin
    module Themes
      class FoldersController < Breeze::Admin::AdminController
        unloadable
        
        def edit
          @path = "/" + Array(params[:id]).join("/")
          if request.put?
            if params[:folder].try(:key?, :name) && !system_folder?(@path)
              @new_path = File.join(File.dirname(@path), params[:folder][:name])
              FileUtils.mv File.join(theme.path, @path), File.join(theme.path, @new_path)
            end
            render :action => :update
          elsif request.delete?
            `rm -r #{File.join theme.path, @path}` unless system_folder?(@path)
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