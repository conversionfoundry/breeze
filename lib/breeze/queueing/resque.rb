module Breeze
  module Queueing
    class ResqueJob
      @queue = :breeze
      
      def self.perform(class_name, id, message, *args)
        if receiver = class_name.constantize.find(id)
          receiver.send message, *args
        end
      end
    end

    class Resque < Strategy
      def add(receiver, message, *args)
        ::Resque.enqueue ResqueJob, receiver.class.name, receiver.id.to_s, message, *args
      end
    end
  end
end