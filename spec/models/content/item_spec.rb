require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

class SearchTestItem < Breeze::Content::Item
  include Breeze::Content::Mixins::Placeable
  field :title
  field :content
  field :extra
  attr_accessible :title, :content, :extra
end

describe Breeze::Content::Item do
  let(:item_1) { SearchTestItem.create(:title => "Foo", :content => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.") } 
  let(:item_2) { SearchTestItem.create(:title => "Lorem", :content => "(Empty)") }
  let(:item_3) { SearchTestItem.create(:content => "laboris", :extra => "Foo") }
  
  describe ".search_for_text('lorem')" do
    before do
      item_1.reload
      item_2.reload
      item_3.reload
    end
    context "query = 'lorem'" do
      before do
        @results = Breeze::Content::Item.search_for_text("Lorem") 
      end

      it "finds related items" do
        @results.should include(item_1, item_2)
      end

      it "excludes unrelated items" do
        @results.should_not include(item_3)
      end
    end
    context "query = 'foo labories'" do
      before { @results = Breeze::Content::Item.search_for_text("Foo laboris") }

      it "finds related items" do 
        @results.should include(item_1, item_3)
      end
    end
  end

end
