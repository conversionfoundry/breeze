require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Analytics" do
  it "is possible to crawl the first page" do
    visit("/")
    status_code.should be(404)
  end
end

