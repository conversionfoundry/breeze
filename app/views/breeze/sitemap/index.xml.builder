xml.instruct! :xml, :version => "1.0"
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  @pages.each do |page|
    xml.url do
      xml.loc        page.permalink(true)
      xml.lastmod    page.updated_at.strftime("%Y-%m-%dT%H:%M:%S") + page.updated_at.formatted_offset
      xml.changefreq "weekly"
      xml.priority   0.5
    end
  end

end