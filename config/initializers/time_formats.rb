Time::DATE_FORMATS[:breeze_date] = "%A %e %B, %Y"
Time::DATE_FORMATS[:breeze_time] = "%l:%M%P"

module ActionView
  module Helpers
    class DateTimeSelector
      def select_hour_with_twelve_hour_time
        datetime = @datetime
        options = @options
        
        return select_hour_without_twelve_hour_time unless options[:twelve_hour].eql? true
        
        if options[:use_hidden]
          build_hidden(:hour, hour)
        else
          val = datetime ? (datetime.kind_of?(Fixnum) ? datetime : datetime.hour) : ''
          hour_options = String.new
          0.upto(23) do |hr|
            ampm = hr <= 11 ? ' AM' : ' PM'
            ampm_hour = hr == 0 || hr == 12 ? 12 : (hr / 12 == 1 ? hr % 12 : hr)
            hour_options << %(<option value="#{hr}"#{' selected="selected"' if val == hr}>#{ampm_hour}#{ampm}</option>\n)
          end
          build_select :hour, hour_options
        end
      end
      alias_method_chain :select_hour, :twelve_hour_time
    end
  end
end