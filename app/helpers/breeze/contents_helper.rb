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
        str = ""
        placements.each { |placement| str << render(inline: placement.to_erb(view)) if placement.content.present? }
        str.html_safe
      end
      @_region_contents[name]
    end
    
    # Navigation Tag
    # Generates a simple ul structure of pages on the site
    # Usage:
    #    Standard one level navigation
    # <%= navigation %>
    #
    # Embed second level within the first (good for hover menus)
    # <%= navigation :recurse => true %>
    #
    # Embed second level within the first, only for active page
    # <%= navigation :recurse => :active %>
    #
    # Duplicate the parent item at the front of the submenu, with a new name
    # <%= navigation :recurse => :active, :home => "Overview" %>
    #
    # Splitting navigation into separate containers
    # <%= navigation :level => 2 %>
    # <%= navigation :level => 2, :home => "Overview" %>
    # <%= navigation :level => 3 %> 
    #    3rd level if need an so on…….
    def navigation(*args, &block)
      levels = { :primary => 1, :secondary => 2, :tertiary => 3 }
      options = args.extract_options!
      level = levels[options[:level]] || (options[:level] || 1).to_i

      args.unshift page if args.empty? && !page.nil?
      
      current_page = page

      contents = "".tap do |str|

        page = current_page # TODO: Can't call page within tap, so we've passed it as a variable. Can we do this better?

        
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

        # If page is undefined, there's no active page
        # This is used for example on the Breeze Commerce Cart and Checkout pages
        # In the longer term, this should be removed, in favour of making the cart a proper page, with checkout as a view
        page ||= nil

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
                # classes << "active" if p == page || (active.index(p).to_i > 0 && p.level == level)
                classes << "first"  if i == 0
                classes << "last"   if i == siblings.length - 1
                classes << p.class.name.demodulize.downcase
              end.join(" ")
            end

            link = if block_given?
              capture p, link_options, &block
            else
              permalink = p.class.name == "Breeze::Content::Placeholder" ? 'javascript:void(0)' : p.permalink
              link_to content_tag(:span, "#{page_title}#{" <small>#{p.subtitle}</small>" if p.subtitle?}".html_safe), permalink, link_options
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
 
      current_page = (defined? page) ? page : nil
      
      contents = "".tap do |str|

        page = current_page # TODO: Can't call page within tap, so we've passed it as a variable. Can we do this better?

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

        # If page is undefined, there's no active page
        # This is used for example on the Breeze Commerce Cart and Checkout pages
        # In the longer term, this should be removed, in favour of making the cart a proper page, with checkout as a view
        page ||= nil
              
        active = page ? (page.root? ? [page] : ancestry.dup) : []
        ancestry << ancestry.last.children.first if ancestry.last
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
              permalink = p.class.name == "Breeze::Content::Placeholder" ? 'javascript:void(0)' : p.permalink
              link_to content_tag(:span, "#{page_title}".html_safe), permalink, link_options
            end
            
            recurse = case options[:recurse]
             when true             then 3
             when :active          then ancestry.include?(p) ? 1 : 0
             when Numeric, /^\d+$/ then options[:recurse].to_i
             else 0
             end
             
             if recurse > 0 && p.level == level && !p.root?
               unless (child = p.children.select(&:show_in_navigation?).first).nil?
                 link << bootstrap_nav(child, options.merge(:level => level + 1, :recurse => recurse - 1), &block)
               end
             end
             
            li_options = ({}).tap do |o|
              o[:class] = [ p.root? ? "home" : p.slug ].tap do |classes|
                classes << "active" if p == page || (active.index(p).to_i > 0 && p.level == level)
                classes << "first"  if i == 0
                classes << "last"   if i == siblings.length - 1
                classes << "dropdown" if p.children.select(&:show_in_navigation?).length > 0
                classes << 'level-' + level.to_s
              end.join(" ")
            end
            
            str << content_tag(:li, link.html_safe, li_options)
          end
        end
        
        # Opening HTML for Twitter Bootstrap Navigation
        str << '</ul>'
        
      end
      contents.html_safe
      
    end
    
    def breadcrumb(divider = "/")
      return nil if page.parent.blank?
      ancestry = page.parent.self_and_ancestors
      content_tag :ul, class: "breadcrumb" do
        ancestry.collect do |ancestor| 
          breadcrumb_link(ancestor) +
          breadcrumb_divider(divider)
        end.join.html_safe
      end
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

  private

    def breadcrumb_link(node)
      content_tag :li do
        link_to(node.title, node.link_to)
      end.html_safe
    end

    def breadcrumb_divider(divider)
      content_tag(:span, class: "divider") do
        divider
      end.html_safe
    end

  end
    
end
