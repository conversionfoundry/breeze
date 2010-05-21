module Breeze
  module ContentsHelper
    unloadable
    
    def region(name, options = {}, &block)
      content = content_for_region(name)
      content = capture(&block) if content.blank? && block_given?
      options[:id] ||= "#{name.to_s.underscore}_region"
      options[:class] = ("breeze-editable-region " + (options[:class] || "")).sub(/\s+$/,"")
      content_tag :div, (content || "").html_safe, options
    end
    
    def content_for_region(name, &block)
      @_region_contents ||= {}
      @_region_contents[name] = capture(&block) if block_given?
      @_region_contents[name]
    end
    
    def navigation(*args, &block)
      levels = { :primary => 1, :secondary => 2, :tertiary => 3 }
      options = args.extract_options!
      level = levels[options[:level]] || (options[:level] || 1).to_i

      args.unshift page if args.empty? && !page.nil?
      
      contents = returning "" do |str|
        pages = args.map do |arg|
          if arg.root?
            arg.children.first
          else 
            case arg
            when Breeze::Content::NavigationItem then arg
            else Breeze::Content::NavigationItem.where(:permalink => arg.to_s).first
            end
          end
        end.flatten.compact
        
        active = page ? page.self_and_ancestors.to_a : []
        
        ancestry = pages.first.self_and_ancestors.to_a
        if level < ancestry.length
          siblings = ancestry[level].self_and_siblings.to_a
          siblings.unshift ancestry[level - 1] if (level == 1 && options[:home] != false) || options[:home]
          siblings.each_with_index do |p, i|
            page_title = if (options[:home] && options[:home] != true) && (p.level < level || p.root?)
              options[:home]
            else
              p.title
            end
            
            link_options = returning({}) do |o|
              o[:class] = returning [ p.root? ? "home" : p.slug ] do |classes|
                classes << "active" if (p == page || active.index(p).to_i > 0) && p.level == level
                classes << "first" if i == 0
                classes << "last" if i == siblings.length - 1
              end.join(" ")
            end
            link = if block_given?
              capture p, link_options, &block
            else
              link_to content_tag(:span, "#{page_title}#{" <small>#{p.subtitle}</small>" if p.subtitle?}".html_safe), p.permalink, link_options
            end
            
            recurse = case options[:recurse]
            when true             then 1
            when :active          then ancestry.include?(p) ? 1 : 0
            when Numeric, /^\d+$/ then options[:recurse].to_i
            else 0
            end
            
            if recurse > 0 && p.level == level && !p.root?
              unless (child = p.children.first).nil?
                link << navigation(child, options.merge(:level => level + 1, :recurse => recurse - 1), &block)
              end
            end
            str << content_tag(:li, link.html_safe, link_options)
          end
        end
      end
      content_tag :ul, contents.html_safe, options.except(:level, :home, :recurse).reverse_merge(:class => "#{levels.invert[level] || "level-#{level}"} navigation")
    end
  end
end