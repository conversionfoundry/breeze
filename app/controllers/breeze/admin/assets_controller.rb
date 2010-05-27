module Breeze
  module Admin
    class AssetsController < AdminController
      unloadable
      
      def index
        
      end
      
      def edit
        @asset = Breeze::Content::Asset.find params[:id]
        render :action => "edit_image" if @asset.image?
      end
    end
  end
end