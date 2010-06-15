module Breeze
  module Admin
    module Themes
      class FilesController < Breeze::Admin::AdminController
        unloadable
        
        def index
          @files = theme.files.sort
        end
        
        def show
          @path = "/" + Array(params[:id]).join("/").gsub("+", " ")
          file_path = theme.file(@path)
          send_file file_path, :type => Mime[File.extname(file_path)[1..-1]].to_s, :disposition => "inline"
        end
        
        def edit
          @path = "/" + Array(params[:id]).join("/").gsub("+", " ")
          if request.put?
            @contents = (params[:file] ? params[:file][:contents] : nil) || ""
            @contents = @contents.force_encoding("utf-8") if @contents.respond_to?(:force_encoding)
            File.open(theme.file(@path), "w") do |f|
              f.write @contents
            end
            if params[:file] && params[:file][:name]
              @old_path = @path
              @path = File.join File.dirname(@old_path), params[:file][:name]
              FileUtils.mv theme.file(@old_path), theme.file(@path)
              render :action => :move
            end
          elsif request.delete?
            FileUtils.rm_r theme.file(@path)
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