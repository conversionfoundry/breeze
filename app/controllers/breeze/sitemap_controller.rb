class Breeze::SitemapController < ActionController::Base
  
  helper :sitemap

  def index
    respond_to do |format|
      format.html
      # format.xml { Sitemap.new } # Use Sitemap class for this. 
    end
  end

end
