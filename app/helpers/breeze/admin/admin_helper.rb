module Breeze::Admin::AdminHelper
  def flash_messages
    if flash.any?
      flash.to_a.map { |key, message|
        content_tag :div, (message + '<a href="#" class="close">&times;</a>').html_safe, :class => "flash #{key}"
      }.join.html_safe
    end
  end
  
  [:form_for, :fields_for].each do |meth|
    src = <<-END_SRC
      def breeze_#{meth}(record_or_name_or_array, *args, &proc)
        options = args.extract_options!
        options[:builder] ||= Breeze::Admin::FormBuilder
        options[:html] ||= {}
        
        class_names = options[:html][:class] ? options[:html][:class].split(" ") : []
        class_names << "breeze-form"
        if options[:as]
          class_names << options[:as]
        else 
          class_names << case record_or_name_or_array
            when String, Symbol then record_or_name_or_array.to_s               # :post => "post"
            when Array then record_or_name_or_array.last.class.to_s.underscore  # [@post, @comment] # => "comment"
            else record_or_name_or_array.class.to_s.underscore                  # @post => "post"
          end
        end
        options[:html][:class] = class_names.join(" ")
        
        #{meth}(record_or_name_or_array, *(args << options), &proc)
      end
    END_SRC
    module_eval src, __FILE__, __LINE__
  end
  
end