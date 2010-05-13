module Breeze
  class ContentsController < ApplicationController
    def show
      render :nothing => true, :status => :not_found
    end
  end
end