require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

class PermalinkTest < Breeze::Content::Item
  field :title
  include Breeze::Content::Mixins::Permalinks
end

describe PermalinkTest do
  # it "should run the validations properly" do
  #   p = PermalinkTest.new :title => "foo"
  #   p.should be_valid
  #   p.slug.should == "foo"
  #   p.permalink.should == "/foo"
  # end
end
