module Breeze
  class ContentsController < Controller

    # Serves pages 
    def show
      @path = "/" + Array(params[:path]).join("/")
      if @path != "/" && file_path = Breeze::Theming::Theme.file(@path)
        request.format = File.extname(file_path)[1..-1]
        response.etag = [ file_path, File.mtime(file_path) ]
        if request.fresh? response
          head :not_modified
        else
          send_file file_path, 
            :type => Mime[File.extname(file_path)[1..-1]].to_s, 
            :disposition => "inline"
        end
      else
        @path.sub!(/\.([^\.]*)$/) { request.format = $1; "" }
        page = Breeze::Content[@path] or raise Breeze::Errors::NotFound, request

        template = page.template || :default
        locals = { 
          page: page,
          template: template
        }
        render file: 'vendor/themes/template/layouts/page.html.erb', locals: locals
      end
    end

  private

    

  end
end
