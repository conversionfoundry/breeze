module Breeze
	class SitemapController < ActionController::Base
	  helper SitemapHelper

	  def index
      @pages = Breeze::Content::Page.order_by(position: :asc)
	    respond_to do |format|
	      format.html
	      format.xml # { Sitemap.new } # Use Sitemap class for this.
	    end
	  end

	end
end