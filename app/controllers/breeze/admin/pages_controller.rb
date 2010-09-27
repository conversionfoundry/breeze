module Breeze
  module Admin
    class PagesController < AdminController
      unloadable
      
      def index
      end
      
      def list
        render :layout => false
      end
      
      def new
        @page = Breeze::Content::NavigationItem.factory((params[:page] || {}).reverse_merge(:_type => "Breeze::Content::Page"))
      end
      
      def create
        Rails.logger.info params[:page].inspect.red
        @page = Breeze::Content::NavigationItem.factory(params[:page])
        @page.save
      end
      
      def edit
        @page = Breeze::Content::NavigationItem.find params[:id]
      end
      
      def update
        @page = Breeze::Content::NavigationItem.find params[:id]
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
        @page = Breeze::Content::NavigationItem.find params[:id]
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