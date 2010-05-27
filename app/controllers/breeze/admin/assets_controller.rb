module Breeze
  module Admin
    class AssetsController < AdminController
      unloadable
      
      def index
        @assets = Breeze::Content::Asset.all
      end
      
      def edit
        @asset = Breeze::Content::Asset.find params[:id]
        render :action => "edit_image" if @asset.image?
      end
      
      def destroy
        @asset = Breeze::Content::Asset.find params[:id]
        @asset.try :destroy
      end
    end
  end
end