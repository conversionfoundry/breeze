module Breeze
  class Sitemap
    
    XmlSitemap = Class.new(Sitemap) do

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

    HtmlSitemap = Class.new(Sitemap) do

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

    DESCENDANTS = [XmlSitemap, HtmlSitemap].freeze # we are not happy with that

    def initialize(format)      
      @format = format 
    end

    def evaluate
      klass = DESCENDANTS.detect { |descendant| descendant.handle?(@format) } 
      klass.new(@format).evaluate
    end

  end
end
