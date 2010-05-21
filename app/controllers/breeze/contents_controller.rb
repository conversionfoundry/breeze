module Breeze
  class ContentsController < Controller
    unloadable
    
    after_filter :add_editing_controls
    
    attr_accessor :view
    
    def show
      @path = "/" + Array(params[:path]).join("/")
      
      if @path != "/" && file_path = Breeze::Theming::Theme.file(@path)
        # TODO: move this into metal
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
    
  protected
    def add_editing_controls
      if admin_signed_in? && request.format.html? && !request.xhr? && view && view.respond_to?(:editor_html)
        response.body = response.body.sub(/(?=<\/body>)/, view.editor_html)
      end
    end
  end
end