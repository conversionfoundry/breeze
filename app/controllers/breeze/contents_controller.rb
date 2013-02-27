module Breeze
  class ContentsController < Controller

    def show
      path = "/" << params[:permalink].to_s
      page = Breeze::Content[path] or raise Breeze::Errors::NotFound, request
      locals = { 
        page: page,
        template: page.template || 'home'
      }
      
      render 'vendor/themes/template/layouts/page', locals: locals
    end

  end
end
