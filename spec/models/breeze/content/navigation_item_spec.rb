require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Breeze::Content::NavigationItem do

  
  let(:parent) { Fabricate :navigation_item}
  subject { Fabricate :navigation_item, parent: parent }
  # Fabricator(:navigation_item, class_name: Breeze::Content::NavigationItem) do
  #   title 'nav_item'
  #   subtitle 'subtitle'
  #   ssl  true
  #   show_in_navigation true
  # end


  describe '#duplicate' do
    it "does a copy" do
      subject.duplicate
      Breeze::Content::NavigationItem.all.should have(3).entries
    end

    it "sets the proper slug" do
      new_record = subject.duplicate
      new_record.slug.should eq('nav_item-2')
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
