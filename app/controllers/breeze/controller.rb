module Breeze
  class Controller < ApplicationController
    unloadable
    
    helper ContentsHelper
    
    rescue_from Breeze::Errors::RequestError do |error|
      respond_to do |format|
        @error = error
        format.html { render :file => "breeze/errors/#{error.to_sym}", :layout => "error", :status => error.status_code }
        format.xml  { render :xml => "", :status => error.status_code }
        format.any  { render :nothing => true, :status => error.status_code }
      end
    end
  end
end