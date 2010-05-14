module Breeze
  class ContentsController < ApplicationController
    unloadable
    
    def show
      @path = "/" + Array(params[:path]).join("/")
      @path.sub!(/\.([^\.]*)$/) { request.format = $1; "" }

      @content = Breeze::Content[@path] or raise Breeze::Errors::NotFound, request
      @content.perform(self, request) or render :nothing => true, :layout => false
    end
    
    rescue_from Breeze::Errors::RequestError do |error|
      respond_to do |format|
        @error = error
        format.html { render :file => "breeze/errors/#{error.to_sym}", :layout => "error", :status => error.to_sym }
        format.xml  { render :xml => "", :status => error.to_sym }
        format.any  { render :nothing => true, :status => error.to_sym }
      end
    end
  end
end