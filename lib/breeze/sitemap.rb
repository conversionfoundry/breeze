class Breeze::Sitemap
  
  DESCENDANTS = [XmlSitemap, HtmlSitemap].freeze # we are not happy with that

  def initialize(format)      
    @format = format 
  end

  def evaluate
    klass = DESCENDANTS.detect { |descendant| descendant.handle?(@content_type) } 
    klass.new(content_type).evaluate
  end

end
