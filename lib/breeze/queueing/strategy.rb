module Breeze
  module Queueing
    class Strategy
      def initialize(options = {})
        options.each_pair do |k, v|
          send :"#{k}=", v
        end
      end
      
      def jobs
        []
      end
      
      def empty?
        jobs.empty?
      end
      
      def self.factory(options = {})
        strategy = options[:strategy] || :synchronous
        begin
          klass = "Breeze::Queueing::#{strategy.to_s.camelize}".constantize
          klass.new options.except(:strategy)
        rescue Exception => e
          Rails.logger.error e.inspect
          Rails.logger.warn "Could not initialize queue: proceeding with synchronous queueing strategy."
          Synchronous.new
        end
      end
      
      def self.to_sym
        name.underscore.to_sym
      end
    end
  end
end