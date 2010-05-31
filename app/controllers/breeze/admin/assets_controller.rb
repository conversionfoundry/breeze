module Breeze
  module Admin
    class AssetsController < AdminController
      unloadable

      def index
        # TODO: sort into folders
        @assets = Breeze::Content::Asset.all.order_by([[ :file, :asc ]])
      end
      
      def create
        @asset = Breeze::Content::Asset.from_upload params
        @asset.save
        respond_to do |format|
          format.html { render :partial => @asset.class.name.demodulize.underscore, :object => @asset, :layout => false }
          format.js
        end
      end
      
      def edit
        @asset = Breeze::Content::Asset.find params[:id]
        render :action => "edit_image" if @asset.image?
      end
      
      def update
        @asset = Breeze::Content::Asset.find params[:id]
        @asset.update_attributes params[:asset]
      end
      
      def destroy
        @asset = Breeze::Content::Asset.find params[:id]
        @asset.try :destroy
      end
    end
  end
end