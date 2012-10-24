require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

# class SearchTestItem < Breeze::Content::Item
#   field :title
#   field :content
#   field :extra
# end

describe Breeze::Content::Item do
  # it "should be its own base class" do
  #   Breeze::Content::Item.base_class.should == Breeze::Content::Item
  # end
  # 
  # describe "when searching for content" do
  #   before :each do
  #     SearchTestItem.collection.drop
  #     @items = []
  #     @items << SearchTestItem.create(:title => "Foo", :content => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
  #     @items << SearchTestItem.create(:title => "Lorem", :content => "(Empty)")
  #     @items << SearchTestItem.create(:content => "Laboris", :extra => "foo")
  #   end
  #   
  #   it "should find the correct items when searching" do
  #     @results = Breeze::Content::Item.search_for_text("lorem")
  #     @results.should include(@items[0], @items[1])
  #     @results.should_not include(@items[2])
  #   end
  #   
  #   it "should find the correct items when searching for multiple terms" do
  #     @results = Breeze::Content::Item.search_for_text("foo laboris")
  #     @results.should include(@items[0], @items[2])
  #     @results.should_not include(@items[1])
  #   end
  # end
end
