# encoding: UTF-8
module Breeze
  class FormResultMailer < Breeze::Mailer
    def new_form_result_admin_notification(form_result)
      @form_result = form_result
      @site = Socket.gethostname
      mail(
      	:to => Breeze.config.form_result_to_email, 
      	:from => Breeze.config.notification_from_email, 
      	:subject => "Result from " + @form_result.form_name + " form at " + @site
      )
    end
  end
end
