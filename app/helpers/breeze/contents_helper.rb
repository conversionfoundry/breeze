module Breeze
  module ContentsHelper
    def region(name, options = {}, &block)
      content = content_for_region(name)
      content = capture(&block) if content.blank? && block_given?
      options[:id] ||= name.to_s.underscore
      options[:class] = ("breeze-editable-region " + (options[:class] || "")).sub(/\s+$/,"")
      content_tag :div, (content || "").html_safe, options
    end
    
    def content_for_region(name, &block)
      @_region_contents ||= {}
      @_region_contents[name] = capture(&block) if block_given?
      @_region_contents[name]
    end
  end
end