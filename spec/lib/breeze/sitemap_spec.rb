require 'spec_helper'


describe Breeze::Sitemap do
  subject { Breeze::Sitemap.new(Mime[:html]) }
  let(:page) { Fabricate :page }
  
  it "renders links" do
    subject.evaluate.should =~ page.permalink
    binding.pry
  end
end
