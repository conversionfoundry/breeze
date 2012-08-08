# encoding: UTF-8
module Breeze
	module Admin
	  class UserAccountMailer < Breeze::Mailer
	    def new_user_account_notification(user)
	      @user = user
	      @site = Socket.gethostname
	      mail(
	      	:to => user.email, 
	      	:from => Breeze.config.notification_from_email, 
	      	:subject => "New user account at " + @site
	      )
	    end
	  end
	end
end
