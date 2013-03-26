module Breeze
  module Admin
    class PagesController < AdminController
      after_filter :expire_all_pages_fragment, except: [:index, :list]

      def index
        @roots ||= Breeze::Content::Page.where(parent_id: nil)
      end
      
      def list
        render :layout => false
      end
      
      def new
        @page = Breeze::Content::Page.new params[:page] 
        # We pass params here to set the parent_id for the new page
      end
      
      def create
        @page = Breeze::Content::Page.new(params[:page])
        respond_to do |format|
          if @page.save 
            Breeze::Admin::Activity.log(:create, @page)
            notice = 'Page created successfully.'
          else
            alert = 'The page could not be saved.'
          end
          format.js
        end
      end
      
      def edit
        @page = Breeze::Content::Page.find params[:id]
      end
      
      def update
        @page = Breeze::Content::Page.find params[:id]
        respond_to do |format|
          if @page.update_attributes(params[:content_page])
            Thread.new(@page) { |p| Breeze::Admin::Activity.log(:update, p) }
            notice = "Page updated."
          else
            notice = "The page could not be updated."
          end
          format.js
          format.html { redirect_to admin_pages_path }
        end
      end
    
      def sort
        @page = Breeze::Content::Page.find params[:id]
        @page.update_attributes params[:page]
      end
      
      def move
        @page = Breeze::Content::Page.find params[:id]
        @page.move! params[:type].to_sym, params[:ref]
      end
      
      def duplicate
        page = Breeze::Content::Page.find params[:id]
        @page = page.duplicate
        render nothing: true, status: 201 # created
      end
      
      def destroy
        @page = Breeze::Content::Page.find params[:id]
        Breeze::Admin::Activity.log(:delete, @page)
        @page.destroy
        respond_to do |format|
          format.js
        end
      end
      
    protected
      def pages
        @pages ||= Breeze::Content::Page.all.order_by([[ :position, :asc ]]).to_a
      end
      helper_method :pages

    private 

      #all_pages fragment is in general used to cache menus
      def expire_all_pages_fragment
        expire_fragment 'all_pages'
      end

    end
  end
end
