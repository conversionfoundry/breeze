module Breeze
  module Errors
    class RequestError < StandardError
      attr_reader :request
      
      def initialize(request)
        @request = request
      end
      
      def to_s
        to_sym.to_s.humanize
      end
      
      def to_sym
        self.class.name.demodulize.underscore.to_sym
      end
      
      def status_code
        to_sym
      end
      
      def method_missing(sym, *args, &block)
        request.send sym, *args, &block
      end
    end
    
    class NotAcceptable < RequestError; end
    
    class NotFound < RequestError; end
  end
end