module Breeze
  module Admin
    module Assets
      class FoldersController < AdminController
        unloadable
        
        def show
          @folder = params[:id] || "/"
          @assets = Breeze::Content::Asset.where({ :folder => @folder }).order_by([[ :file, :asc ]])
        end
        
        def create
          
        end
      end
    end
  end
end