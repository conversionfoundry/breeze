module Breeze
  module Admin
    class ContentsController < AdminController
      before_filter :load_container_and_placement, :only => [ :edit, :update, :duplicate, :destroy, :live ]
      
      def new
        #preview = PreviewHelper.new
        #preview.screenshot(self, request)
        @content = Breeze::Content::Item.factory("Breeze::Content::Snippet", params[:content])
      end
      
      def create
        @content = Breeze::Content::Item.factory("Breeze::Content::Snippet", params[:content])
        if @content.save
          @placement = @content.placement
          #todo
          #@container = @placement.container
          #@container.save
          @container = Breeze::Content::Item.find @content.container_id
          @view = @container.views.by_name(@placement.view).populate(@container, self, request)
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
        @container.save
        @view = @container.views.by_name(@placement.view).populate(@container, self, request)
      end

      def live
        @content = @placement.content
        @content.attributes = params[:content]
        @view = @container.views.by_name(@placement.view).populate(@container, self, request)
      end

      def add
        @content = Breeze::Content::Item.factory("Breeze::Content::Snippet", params[:content])
        @container ||= Breeze::Content::Item.find(@content.container_id) if @content.container_id

        @placement = @container.placements.new(:region => @content.region, :view => @content.view || "default", :position => nil, :content => @content)
        @view = @container.views.by_name(@placement.view).populate(@container, self, request)
      end
      
      def duplicate
        @old_placement, @placement = @placement, @placement.duplicate(@container).unlink!
        @view = @container.views.by_name(@placement.view).populate(@container, self, request)
      end
      
      def insert
        @content = Breeze::Content::Item.find params[:id]
        @container = Breeze::Content::Item.find params[:container_id]
        @container.save
        @placement = @content.add_to_container @container, params[:region], params[:view]
        @view = @container.views.by_name(@placement.view).populate(@container, self, request)
      end
      
      def destroy
        if @container && @placement
          if @placement = @container.placements.by_id(params[:id])
            @placement.destroy
            @container.save
          end
        end
      end
      
      def search
        @container = Breeze::Content::Item.find params[:container_id]
        @view = @container.views.by_name(params[:view]).populate(@container, self, request)
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
