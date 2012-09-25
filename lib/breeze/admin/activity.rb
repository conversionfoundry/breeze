module Breeze
  module Admin
    module Activity
      def self.log(verb, *objects)
        options = objects.extract_options!
        klass = options.delete(:class) || LogMessage
        new_log_message = klass.new(:user_id => User.current.try(:id), :verb => verb.to_s, :options => options || {}) do |msg|
          msg.objects << objects.flatten
        end
        previous_log_message = LogMessage.last
        
        if new_log_message === previous_log_message
          previous_log_message.objects << objects
          previous_log_message.save
          previous_log_message
        else
          new_log_message.save
          new_log_message
        end
      end
    end
  end
end