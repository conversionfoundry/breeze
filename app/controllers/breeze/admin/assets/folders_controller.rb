module Breeze
  module Admin
    module Assets
      class FoldersController < AdminController
        unloadable
        
        def index
          show
          render :action => :show
        end
        
        def show
          @folder = File.join "/", (params[:id] || "/")
          @assets = Breeze::Content::Asset.where({ :folder => @folder }).order_by([[ :file, :asc ]])
        end
        
        def create
          @folder = params[:folder_name] || "new"
          @parent = params[:parent_folder] || "/"
          @folder = File.join @parent, @folder
          FileUtils.mkdir_p File.join(Breeze::Content::Asset.root, @folder)
        end
        
        def update
          @folder = File.join "/", (params[:id] || "/")
          if @new_folder = params[:folder] && params[:folder][:name]
            @new_folder = File.join File.dirname(@folder), @new_folder
            FileUtils.mkdir_p File.join(Breeze::Content::Asset.root, @new_folder)
            Breeze::Content::Asset.where({ :folder => /^#{@folder}(\/.*)?$/ }).each do |file|
              file.folder = @new_folder
              file.save
            end
            FileUtils.rm_r File.join(Breeze::Content::Asset.root, @folder)
          end
          render :nothing => true
        end
        
        def destroy
          @folder = File.join "/", (params[:id] || "/")
          Breeze::Content::Asset.where({ :folder => /^#{@folder}(\/.*)?$/ }).each(&:destroy)
          FileUtils.rm_r File.join(Breeze::Content::Asset.root, @folder)
        end
      end
    end
  end
end