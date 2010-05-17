module Breeze
  module Admin
    module Themes
      class FoldersController < Breeze::Admin::AdminController
        def edit
          @path = "/" + Array(params[:id]).join("/")
          if request.put?

          elsif request.delete?
            `rm -r #{File.join theme.path, @path}`
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