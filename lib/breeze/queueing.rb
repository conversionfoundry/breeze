module Breeze
  module Queueing
    def queue(receiver = nil, message = nil, *args)
      if receiver
        background_queue.add receiver, message, *args
      else
        background_queue
      end
    end
    
    def queueing
      @queueing ||= { :strategy => :synchronous }
    end
    
    def queueing=(config)
      @background_queue = nil
      @queueing = config
    end
    
    def background_queue
      @background_queue ||= Strategy.factory(queueing)
    end
  end
end