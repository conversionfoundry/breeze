class SitemapController < ActionController::Base
  
  def index
    flow = Breeze::Sitemap.new(request.format).evaluate
    # respond_to do |format|
    #   format.html
    #   format.xml { render: flow }
    # end
  end

end
