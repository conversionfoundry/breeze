class HtmlSitemap < Sitemap

  def self.handle?(format)
    format == Mime[:html]
  end

  def evaluate
    Nokogiri::HTML::Builder.new(encoding: 'UTF-8') do |doc|
      doc.html {
        doc.body {
          doc.text(content)
        }
      }
    end
  end

  private

  def content 
    pages_links = Breeze::Content::Page.all.map do |p|
      page_link(1, p.title, p.permalink)
    end
    pages_links.shelljoin
  end

  def page_link(level, title, link)
    %Q(
      #{prefix(level)}
      <a href='#{link}'>
        #{title}
      </a>\n
    )
  end

  def prefix(level)
    s = '|'
    level.times { s += '-' }
  end

end
