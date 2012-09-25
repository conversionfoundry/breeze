module Breeze
  module Queueing
    class ResqueJob
      @queue = :breeze
      
      def self.perform(class_name, id, message, *args)
	      receiver = self.fetch class_name, id
        if receiver
          receiver.send message, *args
        else
          raise "Couldn't process #{[class_name, id, message, *args].inspect}"
        end
      end
      
    protected
      def self.fetch(class_name, id)
        id = id.to_s
        klass = class_name.constantize
        klass.where(:_id => id).first ||
        klass.where(:_id => BSON::ObjectID.from_string(id)).first
      end
    end

    class Resque < Strategy
      def add(receiver, message, *args)
        ::Resque.enqueue ResqueJob, receiver.class.name, receiver.id.to_s, message, *args
      end
    end
  end
end