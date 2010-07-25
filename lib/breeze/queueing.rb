module Breeze
  module Queueing
    def queue(receiver, message, *args)
      background_queue.add receiver, message, *args
    end
    
    def background_queue
      @background_queue ||= Strategy.factory(queue_config)
    end
    
  protected
    def queue_config
      @queue_config ||= returning({}) do |config|
        config[:strategy] = :synchronous
      end
    end
  end
end