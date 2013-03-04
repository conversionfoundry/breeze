require 'spec_helper'

describe "Analytics" do
  it "is possible to crawl the first page" do
    visit("/")
    status_code.should be(404)
  end
end

