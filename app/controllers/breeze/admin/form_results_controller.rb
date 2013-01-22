module Breeze
  module Admin
    class FormResultsController < AdminController
      def index
        @form_results = Breeze::Forms::FormResult.order_by(:created_at.desc)
      end
      
      def destroy
        @form_result = Breeze::Forms::FormResult.find params[:id]
        if @form_result
          @form_result.destroy
        end
      end

    end
  end
end
