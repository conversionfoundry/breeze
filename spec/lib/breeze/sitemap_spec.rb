require 'spec_helper'


describe Breeze::Content::Sitemap do
  subject { Breeze::Content::Sitemap.new('text/html') }
  let(:page) { Fabricate :page }
  
  it "renders links" do
    # require 'pry'; binding.pry
    subject.evaluate =~ page.permalink
  end

end
