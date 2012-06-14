module Breeze
  module ContentsHelper
    def region(name, options = {}, &block)
      content = content_for_region(name, &block)
      options[:id] ||= "#{name.to_s.underscore}_region"
      options[:class] = ("breeze-editable-region " + (options[:class] || "")).sub(/\s+$/,"")
      content_tag :div, (content || "").html_safe, options
    end
    
    def content_for_region(name, &block)
      @_region_contents ||= {}
      placements = page.placements.for(:region => name, :view => view)
      @_region_contents[name] = if placements.empty?
        block_given? ? capture(&block) : ""
      else
        "".tap do |str|
          placements.each do |p|
            begin
              str << render(:inline => p.to_erb(view))
            rescue Exception => e
              content_tag :div, e.to_s, :class => "breeze-content #{p.content.html_class} content_#{p.content_id}#{" shared" if p.shared?}", :id => "content_#{p.content_id}"
            end
          end
        end.html_safe
      end
      @_region_contents[name]
    end
    
    # Navigation Tag
    # Generates a simple ul structure of pages on the site
    def navigation(*args, &block)
      levels = { :primary => 1, :secondary => 2, :tertiary => 3 }
      options = args.extract_options!
      level = levels[options[:level]] || (options[:level] || 1).to_i

      args.unshift page if args.empty? && !page.nil?
      
      contents = "".tap do |str|
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
        
        ancestry = pages.first ? pages.first.self_and_ancestors.to_a : [ page ]
        active = page ? (page.root? ? [page] : ancestry.dup) : []
        ancestry << ancestry.last.children.first
        ancestry.compact!
        if level <= ancestry.length && ancestry[level].present?
          siblings = ancestry[level].self_and_siblings.to_a.select(&:show_in_navigation?)
          siblings.unshift ancestry[level - 1] if options[:home] || (level == 1 && options[:home] != false)
          siblings.each_with_index do |p, i|
            page_title = if (options[:home] && options[:home] != true) && (p.level < level || p.root?)
              options[:home]
              case options[:home]
              when true   then p.title
              when Symbol then p.send options[:home]
              when Proc   then options[:home].call(p)
              else options[:home].to_s
              end
            else
              p.title
            end
            page_title = p.title if page_title.blank?
            
            link_options = ({}).tap do |o|
              o[:class] = [ p.root? ? "home" : p.slug ].tap do |classes|
                classes << "active" if p == page || (active.index(p).to_i > 0 && p.level == level)
                classes << "first"  if i == 0
                classes << "last"   if i == siblings.length - 1
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
      content_tag :ul, contents.html_safe, options.except(:level, :recurse).reverse_merge(:class => "#{levels.invert[level] || "level-#{level}"} navigation")
    end
        
    # First stab at a Twitter Bootstrap compatible navigation menu
    # TODO: Decide whether to do this sort of thing.
    # Arguments:
    # :level => [1,2,3] (level one appears on all pages, 2 only on level a pages, 3 on level 2 pages, etc.)
    # :recurse => [true/false,:active,numeric] (level one appears on all pages, 2 only on level a pages, 3 on level 2 pages, etc.)
    # :home => [true/false] (include or exclude the home link)
    def bootstrap_nav(*args, &block)
      levels = { :primary => 1, :secondary => 2, :tertiary => 3 }
      options = args.extract_options!
      level = levels[options[:level]] || (options[:level] || 1).to_i

      # If there are no arguments, use the current page
      args.unshift page if args.empty? && !page.nil?
      
      contents = "".tap do |str|
        # Opening HTML for Twitter Bootstrap Navigation
        if level == 1
          str << '<ul class="nav">'
        else
          str << '<ul class="dropdown-menu">'
        end
            
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
                                        
        ancestry = pages.first ? pages.first.self_and_ancestors.to_a : [ page ]
        
        active = page ? (page.root? ? [page] : ancestry.dup) : []
        ancestry << ancestry.last.children.first
        ancestry.compact!
                        
        if level <= ancestry.length && ancestry[level].present?
          siblings = ancestry[level].self_and_siblings.to_a.select(&:show_in_navigation?)          
          # siblings = page.self_and_siblings.to_a.select(&:show_in_navigation?)          
          siblings.unshift ancestry[level - 1] if options[:home] || (level == 1 && options[:home] != false)
          siblings.each_with_index do |p, i|
            page_title = if (options[:home] && options[:home] != true) && (p.level < level || p.root?)
              options[:home]
              case options[:home]
              when true   then p.title
              when Symbol then p.send options[:home]
              when Proc   then options[:home].call(p)
              else options[:home].to_s
              end
            else
              p.title
            end
            page_title = p.title if page_title.blank?
            
            link_options = ({}).tap do |o|
              o[:class] = [ p.root? ? "home" : p.slug ].tap do |classes|
                classes << "active" if p == page || (active.index(p).to_i > 0 && p.level == level)
                classes << "first"  if i == 0
                classes << "last"   if i == siblings.length - 1
              end.join(" ")
            end
            
            link = if block_given?
              capture p, link_options, &block
            else
              link_to content_tag(:span, "#{page_title}".html_safe), p.permalink, link_options
            end
            
            recurse = case options[:recurse]
             when true             then 3
             when :active          then ancestry.include?(p) ? 1 : 0
             when Numeric, /^\d+$/ then options[:recurse].to_i
             else 0
             end
             
             if recurse > 0 && p.level == level && !p.root?
               unless (child = p.children.first).nil?
                 link << bootstrap_nav(child, options.merge(:level => level + 1, :recurse => recurse - 1), &block)
               end
             end
             
            # if options[:full] && p.children
            #    p.children.each do |child|
            #      link << navigation_bootstrap(child, options.merge(:full => true), &block)
            #    end
            #  end
             
            li_options = ({}).tap do |o|
              o[:class] = [ p.root? ? "home" : p.slug ].tap do |classes|
                classes << "active" if p == page || (active.index(p).to_i > 0 && p.level == level)
                classes << "first"  if i == 0
                classes << "last"   if i == siblings.length - 1
                classes << "dropdown" if p.children.length > 0
              end.join(" ")
            end
            
            
            str << content_tag(:li, link.html_safe, li_options)
          end
        end
        
        # Opening HTML for Twitter Bootstrap Navigation
        str << '</ul>'
        
      end
      # content_tag :div, contents.html_safe, options.except(:level, :recurse).reverse_merge(:class => "#{levels.invert[level] || "level-#{level}"} navigation")
      contents.html_safe
      
    end
    
    
  end
end
