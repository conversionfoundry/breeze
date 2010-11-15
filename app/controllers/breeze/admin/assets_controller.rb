module Breeze
  module Admin
    class AssetsController < AdminController
      def index
        @folder = params[:folder] || "/"
        @assets = Breeze::Content::Asset.where({ :folder => @folder }).order_by([[ :file, :asc ]])
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
      
      def images
        @images = Breeze::Content::Image.by_folder do |i|
          { :filename => i[:file], :width => i.image_width, :height => i.image_height, :title => i.title }
        end
        render :json => @images
      end
    
    protected
      def folders
        @folders ||= Breeze::Content::Asset.folders
      end
      helper_method :folders
    end
  end
end