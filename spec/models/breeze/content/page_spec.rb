require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Breeze::Content::Page do

  subject { Fabricate :page }

  describe "Factory" do
    it { should be_valid }
  end

  describe "Validations" do
  end

  describe "#page_title" do
    it "selects the seo optimized title if possible" do
      subject.page_title.should eq('seo_title')
    end

    it "defaults to the normal title if there is no seo_title" do
      subject.seo_title = ""
      subject.page_title.should eq('my_super_page')
    end
  end

  describe "#duplicate" do
    let(:duplicata) { subject.duplicate }

    it "returns the created object" do
      duplicata.id.should_not eq(subject.id)
      duplicata.page_title.should eq("seo_title")
    end

    it "deep copy embedded elements" do
      subject.content_items.push(
        Breeze::Content::TypeInstance.new(region: 'region_title')
      )
      duplicata.content_items.size.should eq(1)
      duplicata.content_items.first.region.should eq('region_title')
    end
  end

  describe ".[]" do
    it "retrieves a page from its permalink" do
      Breeze::Content::Page[subject.permalink].should eq(subject)
    end
  end

end
