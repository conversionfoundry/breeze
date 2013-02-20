module Breeze
  class ContentsController < Controller

    # Serves pages 
    def show
      # if @path != "/" && file_path = Breeze::Theming::Theme.file(@path)
      #   request.format = File.extname(file_path)[1..-1]
      #   response.etag = [ file_path, File.mtime(file_path) ]
      #   if request.fresh? response
      #     head :not_modified
      #   else
      #     send_file file_path, 
      #       :type => Mime[File.extname(file_path)[1..-1]].to_s, 
      #       :disposition => "inline"
      #   end
      # else
        # @path.sub!(/\.([^\.]*)$/) { request.format = $1; "" }
      path = "/" << params[:permalink].to_s
      page = Breeze::Content[path] or raise Breeze::Errors::NotFound, request
      locals = { 
        page: page,
        template: page.template || 'home'
      }
      render file: 'vendor/themes/template/layouts/page', locals: locals
      # end
    end

  end
end
