module Breeze
  class StylesheetsController < Controller
    def show
      @path = "/stylesheets/" + Array(params[:path]).join("/")
      
      if @path != "/" && file_path = Breeze::Theming::Theme.file(@path)
        response.etag = [ file_path, File.mtime(file_path) ]
        # TODO: changes to theme style parameters will stale this cache
        if request.fresh? response
          head :not_modified
        else
          engine = Sass::Engine.new(File.read(file_path), :syntax => :scss)
          render :text => engine.render, :content_type => "text/css", :layout => false
        end
      else
        raise Breeze::Errors::NotFound, request
      end
    end
  end
end