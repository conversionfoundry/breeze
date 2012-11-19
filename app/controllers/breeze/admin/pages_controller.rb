module Breeze
  module Admin
    class PagesController < AdminController
      def index
        @roots ||= Breeze::Content::NavigationItem.where(parent_id: nil)
      end
      
      def list
        render :layout => false
      end
      
      def new
        @page = Breeze::Content::Page.new params[:page] # We pass params here to set the parent_id for the new page
      end
      
      def create
        @page = Breeze::Content::Page.create(params[:page])
      end
      
      def edit
        @page = Breeze::Content::Page.find params[:id]
      end
      
      def update
        @page = Breeze::Content::Page.find params[:id]
        @page.update_attributes params[:page]
        respond_to do |format|
          format.js
          format.html { redirect_to @page.permalink }
        end
      end
      
      def sort
        @page = Breeze::Content::NavigationItem.find params[:id]
        @page.update_attributes params[:page]
      end
      
      def move
        @page = Breeze::Content::NavigationItem.find params[:id]
        @page.move! params[:type].to_sym, params[:ref]
      end
      
      def duplicate
        @page = Breeze::Content::Page.find params[:id]
        @page = @page.duplicate
        render :action => :create
      end
      
      def destroy
        @page = Breeze::Content::NavigationItem.find params[:id]
        @page.destroy
      end
      
    protected
      def pages
        @pages ||= Breeze::Content::NavigationItem.all.order_by([[ :position, :asc ]]).to_a
      end
      helper_method :pages
    end
  end
end
