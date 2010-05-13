module Breeze::Admin::LayoutsHelper
  class PaneLayout
    attr_reader :options

    def initialize(context, options = {})
      @context = context
      @options = options || {}
      @inner = ""
      @footer = ""
    end
    
    def header(options = {}, &block)
      (options[:header] ||= {}).merge! options
      @header = @context.capture(&block)
    end
    
    def inner(options = {}, &block)
      (options[:inner] ||= {}).merge! options
      @inner = @context.capture(&block)
    end
    
    def footer(options = {}, &block)
      (options[:footer] ||= {}).merge! options
      @footer = @context.capture(&block)
    end
    
    def to_html
      @context.content_tag :div, (header_html + inner_html + footer_html).html_safe, options.reverse_merge(:id => :layout), false
    end
    
  protected
    def has_footer?
      options[:footer] != false
    end
  
    def header_html
      @context.content_tag(:div, @header || "<h2>#{options[:title]}</h2>".html_safe, (options[:header] || {}).reverse_merge(:class => "header"), false)
    end
    
    def inner_html
      @context.content_tag(:div, @inner, (options[:inner] || {}).reverse_merge(:class => "inner", :style => "bottom: #{has_footer? ? 25 : 0}px"), false)
    end
  
    def footer_html
      (has_footer? ? @context.content_tag(:div, @footer, (options[:footer] || {}).reverse_merge(:class => "footer"), false) : "").html_safe
    end
  end
  
  class TabbedLayout < PaneLayout
    attr_reader :tabs
    
    def initialize(context, options = {})
      super(context, options.reverse_merge(:id => "main-tabs"))
      @tabs = []
    end
    
    def tab(name, options = {}, &block)
      tabs << {
        :name    => name,
        :title   => options[:title] || name.humanize,
        :content => @context.capture(&block).html_safe,
        :options => options
      }
    end
    
    def method_missing(sym, *args, &block)
      tab(sym.to_s, *args, &block)
    end
  
  protected
    def header_html
      @context.content_tag :div, @context.content_tag(:ul, tabs.map { |t|
        @context.content_tag(:li, @context.link_to(t[:title], "#tab_#{t[:name]}").html_safe, { :class => "#{:active if options[:current].to_s == t[:name].to_s}" }, false)
      }.join("\n").html_safe, { :class => :tabs }, false) + @header.to_s, :id => "#{options[:id] || "main-tabs"}-tabs", :class => "header"
    end
    
    def inner_html
      @context.content_tag :div, tabs.map { |t|
        @context.content_tag(:div, t[:content], { :class => "tab-pane", :id => "tab_#{t[:name]}", :style => "display: #{options[:current].to_s == t[:name].to_s ? :block : :none};" }, false)
      }.join("\n").html_safe, :id => "#{options[:id] || "main-tabs"}-content"
    end
  end
  
  def tabbed_layout(options = {})
    tabs = TabbedLayout.new(self, options)
    yield tabs
    tabs.to_html
  end
  
  def pane_layout(options = {})
    panes = PaneLayout.new(self, options)
    yield panes
    panes.to_html
  end
  
  def collapsible_section(options = {}, &block)
    open = !!options.delete(:open)
    header = content_tag :h3, options.delete(:title) || "Show more"
    content = content_tag :div, capture(&block), :class => "collapsible-inner", :style => "display: #{open ? 'block' : 'none'};"
    content_tag(:div, header + content, options.reverse_merge(:class => "collapsible-section #{open ? 'open' : 'closed'}"))
  end
end