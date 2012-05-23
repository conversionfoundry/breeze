module Breeze
  class ContentsController < Controller
    after_filter :add_editing_controls
    
    attr_accessor :view
    
    def show
      binding.pry
      @path = "/" + Array(params[:path]).join("/")
      if @path != "/" && file_path = Breeze::Theming::Theme.file(@path)
        request.format = File.extname(file_path)[1..-1]
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
      if request.format.try :html?
        if protect_against_forgery?
          response.body = response.body.sub /(?=<\/head>)/, %(<meta name="csrf-param" content="#{Rack::Utils.escape_html(request_forgery_protection_token)}"/>\n<meta name="csrf-token" content="#{Rack::Utils.escape_html(form_authenticity_token)}"/>\n).html_safe unless /meta name="csrf-token"/ === response.body
          response.body = response.body.sub /(?=<\/head>)/, %(<meta name="session-key" content="#{Rails.configuration.session_options[:key]}"/>\n<meta name="session-id" content="#{cookies[Rails.configuration.session_options[:key]]}"/>\n).html_safe
        end
      
        if admin_signed_in? && !request.xhr? && view && view.respond_to?(:editor_html)
          response.body = response.body.sub /(?=<\/body>)/, view.editor_html
        end
      end
    end
  end
end
