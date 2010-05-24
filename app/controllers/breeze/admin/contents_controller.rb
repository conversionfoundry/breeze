module Breeze
  module Admin
    class ContentsController < AdminController
      unloadable
      
      before_filter :load_container_and_placement, :only => [ :edit, :update, :duplicate, :destroy ]
      
      def new
        @content = Breeze::Content::Item.factory("Breeze::Content::Snippet", params[:content])
      end
      
      def create
        @content = Breeze::Content::Item.factory("Breeze::Content::Snippet", params[:content])
        if @content.save
          @placement = @content.placement
          @container = @placement.container
          @view = @container.views.by_name(@placement.view)
        end
        respond_to do |format|
          format.js
        end
      end
      
      def edit
        @content = @placement.content
      end
      
      def update
        # TODO: check for unlinking here
        @content = @placement.content
        @content.update_attributes params[:content]
      end
      
      def duplicate
        @old_placement, @placement = @placement, @placement.duplicate.unlink!
      end
      
      def destroy
        if @container && @placement
          if @placement = @container.placements.by_id(params[:id])
            @placement.destroy
          end
        end
      end
      
    protected
      def load_container_and_placement
        if @container = Breeze::Content::Item.where('placements._id' => params[:id]).first
          @placement = @container.placements.by_id(params[:id])
        end
      end
    end
  end
end