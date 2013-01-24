module Breeze
	class SitemapController < ActionController::Base
	  helper SitemapHelper

	  def index
	    respond_to do |format|
	      format.html
	      # format.xml { Sitemap.new } # Use Sitemap class for this. 
	    end
	  end

	end
end