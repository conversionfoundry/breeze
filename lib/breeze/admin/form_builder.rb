module Breeze
  module Admin
    class FormBuilder < ActionView::Helpers::FormBuilder
      unloadable
      
      attr_reader :template
      
      def fieldset(options = {}, &block)
        contents = returning "" do |str|
          str << (options.key?(:legend) ? template.content_tag(:legend, options.delete(:legend)) : "")
          str << template.content_tag(:ol, :class => :form, &block)
        end.html_safe
        template.content_tag :fieldset, contents, options
      end

      (field_helpers - %w(label check_box radio_button fields_for hidden_field)).each do |sym|
        src, line = <<-end_src, __LINE__ + 1
          def #{sym}(method, options = {})
            wrap method, super(method, filter_options(options)), options
          end
        end_src
        class_eval src, __FILE__, line
      end
      
      def select(method, choices, options = {}, html_options = {})
        wrap method, super(method, choices, filter_options(options), html_options), options
      end
      
      def label(method, text = nil, options = {})
        returning super do |str|
          if options[:required]
            str.gsub! /<\/label>$/, "<abbr title=\"required\">*</abbr></label>"
          end
        end.html_safe
      end
      
    protected
      def wrap(method, input, options)
        contents = returning "" do |str|
          str << label(method, options[:label], :required => options[:required]) unless options[:label] == false
          str << input
          str << template.content_tag(:p, options[:hint], :class => "inline-hint") if options[:hint]
        end
        template.content_tag :li, contents.html_safe, (options[:wrapper] || {})
      end
      
      def filter_options(options)
        options.except *%w(label hint)
      end
      
      def sanitize_id(name)
        name.to_s.gsub(']','').gsub(/[^-a-zA-Z0-9:.]/, "_")
      end
    end
  end
end