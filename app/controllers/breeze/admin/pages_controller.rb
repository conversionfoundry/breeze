module Breeze
  module Admin
    class PagesController < AdminController
      def index
        @pages = Breeze::Content::NavigationItem.all.order_by [[ :position, :asc ]]
      end
      
      def new
        @page = Breeze::Content::NavigationItem.factory(params[:page])
      end
      
      def create
        @page = Breeze::Content::NavigationItem.factory(params[:page])
        if @page.save
          @pages = Breeze::Content::NavigationItem.all
        end
      end
      
      def edit
        @page = Breeze::Content::NavigationItem.find params[:id]
      end
    end
  end
end