# encoding: UTF-8
module Breeze
  class FormResultMailer < Breeze::Mailer
    def new_form_result_admin_notification(form_result, recipient_email=nil, sender_email=nil, replyto_email=nil)
      @form_result = form_result
      @site = Socket.gethostname
      @recipient_email = recipient_email || Breeze.config.form_result_to_email
      @sender_email = sender_email || Breeze.config.notification_from_email
      @replyto_email = @replyto_email || @sender_email

      template_name = "#{form_result.form_name.gsub(" ","_").downcase}_admin_notification"

      mail(
      	to: @recipient_email,
      	from: @sender_email,
        reply_to: @replyto_email,
      	subject: "[#{@site} Form Result] #{@form_result.form_name}",
      )

      if themed_template = themed_template_path(template_name)
        message.body = render( themed_template )
      end
      # otherwise, we'll fall back to the default template

    end


  private

    # Returns a path to the first template in an enabled theme with the given name
    def themed_template_path(template_name)
      Breeze::Theming::Theme.enabled.each do |theme|
        if theme.has_file? "/mail_templates/breeze/form_result_mailer/" + template_name + ".html"
          return theme.path + '/mail_templates/breeze/form_result_mailer/' + template_name
        end
      end
      nil
    end

  end
end
