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
        @placement.unlink! if @placement.shared? && !params[:update_all]
        @content = @placement.content
        @content.update_attributes params[:content]
      end
      
      def duplicate
        @old_placement, @placement = @placement, @placement.duplicate.unlink!
      end
      
      def insert
        @content = Breeze::Content::Item.find params[:id]
        @container = Breeze::Content::Item.find params[:container_id]
        @placement = @content.add_to_container @container, params[:region], params[:view]
      end
      
      def destroy
        if @container && @placement
          if @placement = @container.placements.by_id(params[:id])
            @placement.destroy
          end
        end
      end
      
      def search
        @results = if params[:q]
          Breeze::Content::Item.search_for_text params[:q], :class => Breeze::Content::Mixins::Placeable
        else
          []
        end
      end
      
      def instances
        @content = Breeze::Content::Item.find params[:id]
        @instances = @content ? @content.containers : []
        render :layout => false
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