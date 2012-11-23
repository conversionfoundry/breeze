module Breeze
  module Admin
    module PagesHelper
      def page_tree_node(page)
        contents = link_to content_tag(:ins, "", :class => 'icon icon-' + page.class.name.demodulize.downcase) + (page.root? ? "Home" : page.title), page.permalink, :title => page.title
        contents << content_tag(:ul, render(:partial => "breeze/admin/pages/page", :collection => page.children.order_by([:position, :asc]))) if page.children.present? 
        content_class = [ page.class.name.demodulize.underscore ]
        if page.children.any?
          content_class << page.root? ? 'open' : 'closed'
        end
        content_class << 'hidden' unless page.show_in_navigation?
        content_tag :li, contents.html_safe, :class => content_class.compact.join(" "), :id => "page_#{page.id}", :rel => (page.root? ? :root : :page)
      end
    end
  end
end
