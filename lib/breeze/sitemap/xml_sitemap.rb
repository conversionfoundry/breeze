class XmlSitemap < Sitemap

  def self.handle?(format)
    format == Mime[:xml]
  end

  def evaluate 
    xml = Builder::XmlMarkup.new(:indent => 2)
    xml.instruct! :xml, :version => "1.0"
    xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do
      Breeze::Content::Page.order_by(:position).each do |page|
        xml.url do
          xml.loc        Breeze.domain + page.permalink
          xml.lastmod    page.updated_at.strftime("%Y-%m-%dT%H:%M:%S") + page.updated_at.formatted_offset
          xml.changefreq "weekly"
          xml.priority   0.5
        end
      end
    end
  end

end
