module Breeze
  module Queueing
    class Synchronous < Strategy
      def add(receiver, message, *args)
        receiver.send message, *args
      end
    end
  end
end