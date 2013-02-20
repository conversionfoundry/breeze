class Breeze::Breadcrumb

  def initialize(args)
    @template = args.fetch(:template)
    @page = args.fetch(:for_page)
    @divider = args.fetch(:divider)
  end

  def generate
    return nil if @page.parent.nil?
    ancestry = @page.parent.self_and_ancestors
    ancestor_links(ancestry)
  end

private

  def h
    @template
  end

  def ancestor_links(ancestry)
    h.content_tag :ul, class: "breadcrumb" do
      all_pages = link_array(ancestry).push(breadcrumb_node_name(@page))
      all_pages.join(breadcrumb_divider(@divider)).html_safe 
    end
  end

  def link_array(ancestry) 
    ancestry.collect do |ancestor| 
      breadcrumb_link(ancestor)
    end
  end

  def breadcrumb_link(node)
    h.content_tag :li do
      link_to(node.title, node.link_to)
    end.html_safe
  end

  def breadcrumb_divider(divider)
    h.content_tag(:span, class: "divider") do
      divider
    end.html_safe
  end

  def breadcrumb_node_name(node)
    h.content_tag :li do
      node.title
    end.html_safe
  end

  
end
