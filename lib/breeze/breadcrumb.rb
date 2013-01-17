class Breeze::Breadcrumb < ActionView::Base
  include ActionView::Helpers::TagHelper

  def initialize(args)
    @page = args.fetch(:for_page)
    @divider = args.fetch(:divider)
  end

  def generate
    return @page.title if @page.parent.nil?
    ancestry = @page.parent.self_and_ancestors
    ancestor_links(ancestry)
  end

private

  def ancestor_links(ancestry)
    content_tag :ul, class: "breadcrumb" do
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
    content_tag :li do
      link_to(node.title, node.link_to)
    end.html_safe
  end

  def breadcrumb_divider(divider)
    content_tag(:span, class: "divider") do
      divider
    end.html_safe
  end

  def breadcrumb_node_name(node)
    content_tag :li do
      node.title
    end.html_safe
  end

  
end
