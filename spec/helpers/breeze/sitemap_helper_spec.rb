require 'spec_helper'


describe Breeze::SitemapHelper do
  let!(:page) { Fabricate(:page) }

  describe 'sitemap_page_link' do
    it "renders a link" do
      helper.sitemap_page_link(1, page).should match(%r{<a href=})
    end
  end

  describe '#prefixe' do
    it "gives a prefix related to the level params" do
      helper.prefix(1).should eq('<br/>| - ') 
      helper.prefix(2).should eq('<br/>| - - ')
    end
  end
end
