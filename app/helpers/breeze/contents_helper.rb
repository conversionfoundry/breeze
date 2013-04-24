module Breeze
  module ContentsHelper
    def region(name, options = {}, &block)
      content = content_for_region(name, &block)
      options[:id] ||= "#{name.to_s.underscore}_region"
      options[:class] = 
        ("breeze-editable-region " + (options[:class] || "")).sub(/\s+$/,"")
      content_tag :div, (content || "").html_safe, options
    end
    
    def content_for_region(name, &block)
      @_region_contents ||= {}
      content_type_instances = page.content_items.where(region: name)
      @_region_contents[name] = if content_type_instances.empty?
        block_given? ? capture(&block) : ""
      else
        str = ""
        content_type_instances.each do |instance| 
          str << content_for_instance(instance) 
        end
        str.html_safe
      end
      @_region_contents[name]
    end

    def content_for_instance(instance)
      render(instance.type.template_name, object: instance)
    end
    
    def breadcrumb(template, page, options = {})
      divider = options[:divider] || '/'
      Breeze::Breadcrumb.new(template: template, for_page: page, divider: divider).generate
    end

    def breeze_form( name='Unnamed form', options={}, &block)
      options.merge!({:remote => true})
      form_tag form_results_path, options do |form|
        content = [].tap do |content|
          content << hidden_field_tag(:form_name, name)
          content << hidden_field_tag(:success_function, options[:success_function]) if options[:success_function]
          content << capture( &block )
        end.join(" ").html_safe
      end.html_safe
    end

  end
    
end
