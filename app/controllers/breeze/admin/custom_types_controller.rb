module Breeze
  module Admin
    class CustomTypesController < AdminController
      def index
        @custom_types = Breeze::Content::Type.asc(:name) 
      end
      
      def new
        @custom_type = Breeze::Content::Type.new
        @custom_type.content_fields.build(position: 0)
      end
      
      def new_field
        @custom_type = Breeze::Content::Type.new
        render(
          :partial => "breeze/admin/custom_types/field", 
          :object => @custom_type.content_fields.build(params[:custom_field])
        )
      end
      
      def create
        @custom_type = Breeze::Content::Type.create params[:content_type]
      end
      
      def edit
        @custom_type = Breeze::Content::Type.find params[:id]
      end
      
      def update
        @custom_type = Breeze::Content::Type.find params[:id]
        @custom_type.update_attributes params[:content_type]
      end
      
      def destroy
        @custom_type = Breeze::Content::Type.find params[:id]
        @custom_type.destroy
      end
    end
  end
end
