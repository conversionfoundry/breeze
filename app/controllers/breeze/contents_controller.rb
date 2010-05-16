module Breeze
  class ContentsController < Controller
    def show
      @path = "/" + Array(params[:path]).join("/")
      
      if @path != "/" && file_path = Breeze::Theming::Theme.file(@path)
        response.etag = [ file_path, File.mtime(file_path) ]
        if request.fresh? response
          head :not_modified
        else
          send_file file_path, :type => Mime[File.extname(file_path)[1..-1]].to_s, :disposition => "inline"
        end
      else
        @path.sub!(/\.([^\.]*)$/) { request.format = $1; "" }
        @content = Breeze::Content[@path] or raise Breeze::Errors::NotFound, request
        @content.render(self, request) or render :nothing => true, :layout => false
      end
    end
  end
end