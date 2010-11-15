module Breeze
  module Admin
    module PagesHelper
      def page_tree_node(page)
        children = pages.select { |p| p.parent_id == page.id }
        contents = link_to content_tag(:ins, "", :class => :icon) + (page.root? ? "Home" : page.title), page.permalink, :title => page.title
        contents << content_tag(:ul, render(:partial => "page", :collection => children)) unless children.empty?
        content_class = [ page.class.name.demodulize.underscore ]
        if page.root? || (@page && @page.permalink.starts_with?(page.permalink + "/"))
          content_class << 'open'
        else
          content_class << 'closed' unless children.empty?
        end
        content_class << 'hidden' unless page.show_in_navigation?
        content_tag :li, contents.html_safe, :class => content_class.compact.join(" "), :id => "page_#{page.id}", :rel => (page.root? ? :root : :page)
      end
    end
  end
end