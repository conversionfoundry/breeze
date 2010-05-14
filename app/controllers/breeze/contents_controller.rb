module Breeze
  class ContentsController < Controller
    def show
      @path = "/" + Array(params[:path]).join("/")
      @path.sub!(/\.([^\.]*)$/) { request.format = $1; "" }

      @content = Breeze::Content[@path] or raise Breeze::Errors::NotFound, request
      @content.render(self, request) or render :nothing => true, :layout => false
    end
  end
end