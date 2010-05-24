if "".respond_to?(:red)
  module ActionController
    module Railties
      class LogSubscriber
        def start_processing(event)
          payload = event.payload
          params  = payload[:params].except(*INTERNAL_PARAMS)

          info "  Processing by #{payload[:controller]}##{payload[:action]} as #{payload[:formats].first.to_s.upcase}".green
          info "  Parameters: #{params.inspect}".yellow unless params.empty?
        end
      end
    end
  end
end