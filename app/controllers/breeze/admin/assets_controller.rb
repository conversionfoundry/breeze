module Breeze
  module Admin
    class AssetsController < AdminController
      unloadable

      # TODO: authenticate file uploads
      # skip_before_filter :verify_authenticity_token, :only => [ :create ]
      skip_before_filter :authenticate_admin!, :only => [ :create ]
      
      def index
        # TODO: sort into folders
        @assets = Breeze::Content::Asset.all.order_by([[ :file, :asc ]])
      end
      
      def create
        # TODO: report status
        render :nothing => true
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