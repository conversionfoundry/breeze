require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Breeze::Content::NavigationItem do

  subject { Fabricate :navigation_item }

  describe '#duplicate' do
    it "should create a new navigation item" do
      subject.duplicate
      Breeze::Content::NavigationItem.count.should eq(2)
    end

    # it "should duplicate its children"

    # it "should set the correct parent id on the dup"

    # it "should keep the old slug for the child"

    # it "should generate a new permalink for the child"
    # it "should not duplicate its contents"
  #     Breeze::Content::Snippet.count.should == 1
  #   end
  #   
  #   it "should share its contents" do
  #     @new_page.placements.first.should be_shared
  #   end
  #   it "should increment the placements_counts of its contents" do
  #     Breeze::Content::Snippet.first.placements_count.should == 2
  #   end
  #   it "should place the new page directly after it" do
  #     @new_page.position.should == @page.position + 1
  #   end
  #   
  #   it "should shove siblings out of the way" do
  #     @sibling.position.should == @new_page.position + 1
  #   end
  end

  describe '#destroy' do
    it "should destroy its contnet"
  end

end
