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
      
      def edit
        @container = Breeze::Content::Item.where('placements._id' => params[:id]).first
        @placement = @container.placements.by_id(params[:id])
        @content = @placement.content
      end
      
      def update
        @container = Breeze::Content::Item.where('placements._id' => params[:id]).first
        @placement = @container.placements.by_id(params[:id])
        # TODO: check for unlinking here
        @content = @placement.content
        @content.update_attributes params[:content]
      end
      
      def duplicate
        @container = Breeze::Content::Item.where('placements._id' => params[:id]).first
        @old_placement = @container.placements.by_id(params[:id])
        @placement = @old_placement.content.add_to_container @container, @old_placement.region, @old_placement.view, @old_placement.position + 1
      end
      
      def destroy
        if @container = Breeze::Content::Item.where('placements._id' => params[:id]).first
          if @placement = @container.placements.by_id(params[:id])
            @placement.destroy
          end
        end
      end
      
    end
  end
end