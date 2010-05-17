module Breeze
  module Admin
    module Themes
      class FilesController < Breeze::Admin::AdminController
        def index
          @files = theme.files.sort
        end
        
        def edit
          @path = "/" + Array(params[:id]).join("/")
          if request.put?
            @contents = params[:file][:contents]
            File.open(theme.file(@path), "w") do |f|
              f.write @contents
            end
          elsif request.delete?
            `rm -r #{File.join theme.path, @path}`
            render :action => :destroy
          else
            @contents = File.read(theme.file(@path))
          end
        end
        
      protected
        def theme
          @theme ||= Breeze::Theming::Theme[params[:theme_id]]
        end
        helper_method :theme
      end
    end
  end
end