module Breeze
  class FormResultsController < Controller
    def create
      form_values = params.except :utf8, :authenticity_token, :action, :controller, :meta

      @form_result = Breeze::Forms::FormResult.new serialized_form_values: form_values, form_name: params[:meta][:form_name]

      @recipient_email = params[ params[:meta][:recipient_email_field] ]
      @sender_email = params[ params[:meta][:sender_email_field] ]
      @replyto_email = params[ params[:meta][:replyto_email_field] ]

      @success_function = params[:meta][:success_function]

      if @form_result.save

        Breeze::FormResultMailer.new_form_result_admin_notification(@form_result, @recipient_email, @sender_email, @replyto_email).deliver

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
