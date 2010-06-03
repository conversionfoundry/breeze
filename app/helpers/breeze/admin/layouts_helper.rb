module Breeze::Admin::LayoutsHelper
  unloadable
  
  class PaneLayout
    attr_reader :options

    def initialize(context, options = {})
      @context = context
      @options = options || {}
      @header, @header_options = "", options.delete(:header) || {}
      @inner, @inner_options = "", options.delete(:inner) || {}
      @footer, @footer_options = "", options.delete(:footer) || {}
    end
    
    def header(*args, &block)
      options = args.extract_options!
      (self.options[:header] ||= {}).merge! options
      @header = capture_content *args, &block
      return
    end
    
    def inner(*args, &block)
      options = args.extract_options!
      (self.options[:inner] ||= {}).merge! options
      @inner = capture_content *args, &block
      return
    end
    
    def footer(*args, &block)
      options = args.extract_options!
      (self.options[:footer] ||= {}).merge! options
      @footer = capture_content *args, &block
      return
    end
    
    def to_html
      @context.content_tag :div, (header_html + inner_html + footer_html).html_safe, options.reverse_merge(:id => :layout), false
    end
    
  protected
    def capture_content(*args, &block)
      returning("") do |str|
        str << args.flatten.join("\n") if args.any?
        str << @context.capture(&block) if block_given?
      end.html_safe
    end
  
    def has_footer?
      !@footer.blank?
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
  
  def pane_layout(options = {})
    panes = PaneLayout.new(self, options)
    yield panes
    panes.to_html
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
        @context.content_tag(:li, @context.link_to(t[:title], "#tab_#{t[:name]}", :class => :tab).html_safe, { :class => "#{:active if options[:current].to_s == t[:name].to_s}" }, false)
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
  
  class SlidingLayout
    attr_reader :options
    attr_reader :pages
    
    def initialize(context, options = {})
      @context = context
      @options = options || {}
      @pages = []
      @page = options.delete(:page) || 1
    end
    
    def page(name, options = {}, &block)
      pages << [ name, @context.capture(&block).html_safe, options ]
      return
    end
    
    def to_html
      @context.content_tag :div, @context.content_tag(:div, content_html, :class => :pages, :style => "left: #{(@page - 1) * 100}%"), options.reverse_merge(:class => :sliding), false
    end
    
    def method_missing(sym, *args, &block)
      page sym, *args, &block
    end
    
  protected
    def content_html
      returning "" do |str|
        pages.each_with_index do |(name, page, options), i|
          str << @context.content_tag(:div, page, options.merge(:style => "left: #{i * 100}%;", :class => :page))
        end
      end.html_safe
    end
  end
  
  def sliding_layout(options = {})
    pages = SlidingLayout.new(self, options = {})
    yield pages
    pages.to_html    
  end
  
  def scrollable_layout(options = {}, &block)
    options[:class] = (Array(options[:class]) + %w(scrollable)).join(" ")
    content_tag :div, options, &block
  end
  
  def collapsible_section(options = {}, &block)
    open = !!options.delete(:open)
    header = content_tag :h3, options.delete(:title) || "Show more"
    content = content_tag :div, capture(&block), :class => "collapsible-inner", :style => "display: #{open ? 'block' : 'none'};"
    content_tag(:div, header + content, options.reverse_merge(:class => "collapsible-section #{open ? 'open' : 'closed'}"))
  end
  
  def fake_right_sidebar(&block)
    content_tag :div, :class => "fake-right-sidebar", &block
  end
end