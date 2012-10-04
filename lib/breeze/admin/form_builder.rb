module Breeze
  module Admin
    class FormBuilder < ActionView::Helpers::FormBuilder
      attr_reader :template
      
      def fieldset(*args, &block)
        options = args.extract_options!
        contents = "".tap do |str|
          str << (options.key?(:legend) ? template.content_tag(:legend, options.delete(:legend)) : "")
          if block_given?
            str << template.content_tag(:ol, :class => :form, &block)
          else
            str << template.content_tag(:ol, (args.first || "").html_safe, :class => :form)
          end
        end.html_safe
        template.content_tag :fieldset, contents, options
      end

      (field_helpers - %w(label check_box radio_button fields_for hidden_field text_area time_zone_select)).each do |sym|
        src, line = <<-end_src, __LINE__ + 1
          def #{sym}(method, options = {})
            if options[:wrap] == false
              super method, filter_options(options)
            else
              wrap method, super(method, filter_options(options).reverse_merge(:class => :#{sym})), options.merge(:kind => :#{sym})
            end
          end
        end_src
        class_eval src, __FILE__, line
      end
      
      def text_area(method, options = {})
        options[:value] = object.send(:"#{method}_source") if object.respond_to?(:"#{method}_source")
        if options[:wrap] == false
          super method, options.except(%w(wrap))
        else
          wrap method, super(method, filter_options(options).reverse_merge(:class => :text_area)), options.merge(:kind => :text_area)
        end
      end
      
      def select(method, choices, options = {}, html_options = {})
        wrap method, super(method, choices, filter_options(options), html_options), options.merge(:kind => :select)
      end
      
      def date_select(method, options = {}, html_options = {})
        wrap method, super(method, filter_options(options), html_options), options.merge(:kind => :date)
      end
      
      def time_select(method, options = {}, html_options = {})
        wrap method, super(method, filter_options(options), html_options), options.merge(:kind => :time)
      end
      
      def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
        wrap method, super(method, priority_zones, filter_options(options), html_options), options.merge(:kind => :time_zone)
      end
      
      def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        wrap method, super(method, filter_options(options).reverse_merge(:class => :check_box), checked_value, unchecked_value) + " " +
          label(method, options[:label] || method.to_s.humanize, :required => options[:required]), options.merge(:label => false, :kind => :check_box)
      end
      
      def radio_button(method, tag_value, options = {})
        wrap method, super(method, tag_value, filter_options(options).reverse_merge(:class => :radio_button)) + " " + label(method, options[:label] || method.to_s.humanize, :required => options[:required]), options.merge(:label => false, :kind => :radio_button)
      end
      
      def label(method, text = nil, options = {})
        text = ((text || options[:label] || method.to_s.humanize) + "<abbr title=\"required\">*</abbr>").html_safe if options[:required]
        super method, text, filter_options(options)
      end
      
      def errors_for(method)
        errors = @object.errors[method.to_sym]
        errors.empty? ? "".html_safe : template.content_tag(:p, errors.uniq.to_sentence.untaint, :class => "inline-errors")
      end
      
      def content_type_select(method = :_type, options = {})
        select_options = "".tap do |str|
          Breeze::Content::Mixins::Placeable.classes.sort_by(&:label).group_by do |klass|
            if klass.ancestors.include?(Breeze::Content::Custom::Instance)
              "Custom types"
            else
              "Built in" 
            end
          end.sort_by(&:first).collect do |group_label, classes|
            str << "<optgroup label=\"#{group_label}\">"
            classes.each do |c|
              str << "<option value=\"#{c.to_s}\"#{' selected="selected"' if c == @object.class}>#{c.label}</option>"
            end
            str << "</optgroup>"
          end
        end.html_safe
        wrap method, template.content_tag(:select, select_options, :name => "#{@object_name}[#{method}]", :id => "#{@object_name}_#{method}"), options
      end
      
    protected
      def wrap(method, input, options)
        contents = "".tap do |str|
          str << label(method, options[:label], :required => options[:required]) unless options[:label] == false
          str << wrap_field(input, options)
          str << errors_for(method) if options[:errors] != false
          str << template.content_tag(:p, options[:hint], :class => "inline-hints") if options[:hint]
        end
        template.content_tag :li, contents.html_safe, (options[:wrap] || {}).reverse_merge(:class => options[:kind])
      end
      
      def wrap_field(input, options = {})
        before, after = [:before, :after].collect do |k|
          options[k] ? template.content_tag(:span, options[k].html_safe, :class => "#{k}-field") : ""
        end
        template.content_tag :span, [ before, input, after ].reject(&:blank?).join("").html_safe, :class => :field
      end
      
      def filter_options(options)
        options.except :label, :hint, :kind, :errors, :required, :wrap, :before, :after
      end
      
      def sanitize_id(name)
        name.to_s.gsub(']','').gsub(/[^-a-zA-Z0-9:.]/, "_")
      end
    end
  end
end
