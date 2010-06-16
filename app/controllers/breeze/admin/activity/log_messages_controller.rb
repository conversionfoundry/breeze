module Breeze
  module Admin
    module Activity
      class LogMessagesController < AdminController
        def index
          @log_messages = LogMessage.order_by([[ :created_at, -1 ]]).paginate :page => params[:page], :per_page => 15
        end
      end
    end
  end  
end