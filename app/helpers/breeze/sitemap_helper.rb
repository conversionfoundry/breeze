module Breeze
  module SitemapHelper

    def sitemap_page_link(level, page)
      stream = prefix(level) + link_to(page.title, page.permalink)
      page.children.each do |child|
        stream += sitemap_page_link(level + 1, child)
      end
      stream
    end

    def prefix(level)
      s = '<br/>| '
      level.times { s += '- ' }
      s
    end

  end
end
