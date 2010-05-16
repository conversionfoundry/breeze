require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Breeze::Content::Item do
  it "should be its own base class" do
    Breeze::Content::Item.base_class.should == Breeze::Content::Item
  end
end