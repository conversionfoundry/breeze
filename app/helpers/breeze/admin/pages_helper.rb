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
        content_class << 'hidden_from_navigation' unless page.show_in_navigation?
        content_tag :li, contents.html_safe, :class => content_class.compact.join(" "), :id => "page_#{page.id}", :rel => (page.root? ? :root : :page)
      end

      def options_for_page_select
        page_tree_array(Breeze::Content::Page.root.first, [])
      end

      def page_tree_array(page, page_array)
        page_array << [("&nbsp;&nbsp;&nbsp;&nbsp;" * (page.self_and_ancestors.count - 1) + page.title).html_safe, page.id ]
        page.children.sort_by{|p| p.position}.each {|p| page_tree_array(p, page_array)}
        page_array
      end

    end
  end
end
