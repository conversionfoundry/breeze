require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Breeze::Content::Page do
  before :each do
    Breeze::Content::Item.collection.drop
    
    @root = Breeze::Content::Page.create :title => "Home", :slug => "", :permalink => "/"
    @page = Breeze::Content::Page.create :title => "Page", :parent => @root
    @sibling = Breeze::Content::Page.create :title => "Sibling", :parent => @root
    @content = Breeze::Content::Snippet.create :content => "Test"
    @content.add_to_container @page, "default", "default"
    
    @page.position.should == 0
    @sibling.position.should == 1
  end
  
  it "should generate its permalink correctly" do
    @page.permalink.should == "/page"
  end

  describe "when duplicated" do
    before :each do
      @new_page = @page.duplicate
      [ @page, @new_page, @sibling ].each &:reload
    end
    
    it "should produce a new database record" do
      Breeze::Content::Page.count.should == 4
    end
    
    it "should have a new slug" do
      @new_page.slug.should == "page-2"
    end

    it "should have a new permalink" do
      @new_page.permalink.should == "/page-2"
    end
    
    it "should duplicate its placements" do
      @new_page.placements.count.should == 1
    end
    
    it "should not duplicate its contents" do
      Breeze::Content::Snippet.count.should == 1
    end
    
    it "should share its contents" do
      @new_page.placements.first.should be_shared
    end
    
    it "should increment the placements_counts of its contents" do
      Breeze::Content::Snippet.first.placements_count.should == 2
    end
    
    it "should place the new page directly after it" do
      @new_page.position.should == @page.position + 1
    end
    
    it "should shove siblings out of the way" do
      @sibling.position.should == @new_page.position + 1
    end
  end
  
  describe "with children" do
    before :each do
      @child = Breeze::Content::Page.create :title => "Child", :parent => @page
    end

    describe "when duplicated" do
      before :each do
        @new_page = @page.duplicate
        @new_child = @new_page.children.first
      end
      
      it "should duplicate its children" do
        Breeze::Content::Page.count.should == 6
      end
      
      it "should set the correct parent_id on the child" do
        @new_child.parent_id.should == @new_page.id
      end
      
      it "should keep the old slug for the child" do
        @new_child.slug.should == "child"
      end
      
      it "should generate a new permalink for the child" do
        @new_child.permalink.should == "/page-2/child"
      end
    end
  end

  describe "when destroyed" do
    it "should delete its content" do
      lambda { @page.destroy }.should change(Breeze::Content::Snippet, :count).by(-1)
    end
  end
end