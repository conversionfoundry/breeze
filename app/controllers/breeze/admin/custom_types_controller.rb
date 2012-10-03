module Breeze
  module Admin
    class CustomTypesController < AdminController
      def index
        @custom_types = Breeze::Content::Custom::Type.asc(:name) 
      end
      
      def new
        @custom_type = Breeze::Content::Custom::Type.new
        @custom_type.custom_fields.build({ :position => 0 }, Breeze::Content::Custom::StringField)
      end
      
      def new_field
        @custom_type = Breeze::Content::Custom::Type.new
        render :partial => "breeze/admin/custom_types/field", :object => @custom_type.custom_fields.build(params[:custom_field])
      end
      
      def create
        @custom_type = Breeze::Content::Custom::Type.create params[:custom_type]
      end
      
      def edit
        @custom_type = Breeze::Content::Custom::Type.find params[:id]
      end
      
      def update
        @custom_type = Breeze::Content::Custom::Type.find params[:id]
        @custom_type.attributes = params[:custom_type]
        @custom_type.save
      end
      
      def destroy
        @custom_type = Breeze::Content::Custom::Type.find params[:id]
        @custom_type.destroy
      end
    end
  end
end
