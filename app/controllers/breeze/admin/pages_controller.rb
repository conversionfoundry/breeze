module Breeze
  module Admin
    class PagesController < AdminController
      unloadable
      
      def index
      end
      
      def new
        @page = Breeze::Content::NavigationItem.factory(params[:page])
      end
      
      def create
        @page = Breeze::Content::NavigationItem.factory(params[:page])
        @page.save
      end
      
      def edit
        @page = Breeze::Content::NavigationItem.find params[:id]
      end
      
      def update
        @page = Breeze::Content::NavigationItem.find params[:id]
        @page.update_attributes params[:page]
      end
      
      def sort
        update
      end
      
      def move
        @page = Breeze::Content::NavigationItem.find params[:id]
        @page.move! params[:type].to_sym, params[:ref]
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