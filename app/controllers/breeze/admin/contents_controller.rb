module Breeze
  module Admin
    class ContentsController < AdminController
      unloadable
      
      def new
        @content = Breeze::Content::Snippet.new(params[:content])
      end
      
      def create
        @content = Breeze::Content::Snippet.create(params[:content])
        @placement = @content.placement
        @container = @placement.container
        @view = @container.views.by_name(@placement.view)
        respond_to do |format|
          format.js
        end
      end
    end
  end
end