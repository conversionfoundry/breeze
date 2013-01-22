module Breeze
  class FormResultsController < Controller
    def create
      form_values = params.except :utf8, :authenticity_token, :action, :controller, :form_name, :success_function
      @form_result = Breeze::Forms::FormResult.new serialized_form_values: form_values, form_name: params[:form_name]
      @success_function = params[:success_function]
      if @form_result.save

        Breeze::FormResultMailer.new_form_result_admin_notification(@form_result).deliver

        respond_to do |format|
          format.js 
          format.html { redirect_to :back }
        end
      else
        redirect_to :back
      end
    end

  end
end
