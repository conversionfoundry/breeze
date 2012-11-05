require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

class PermalinkTest < Breeze::Content::Item
  field :title
  belongs_to :parent, class_name: PermalinkTest
  include Breeze::Content::Mixins::Permalinks
  include Breeze::Content::Mixins::TreeStructure
end

describe "Permalink" do
  subject { PermalinkTest.new(title: 'home') }
  let(:taken_slugs) { %w(home home-2 home-3) }
  let(:parent) { PermalinkTest.new(slug: 'parent') }
  let(:grandparent) { PermalinkTest.new(slug: 'grandparent') }

  describe "#generate_slug(default_slug, *taken_slugs)" do
    it "generates the next available slug" do
      Breeze::Content::Item.stub_chain(:where, :map) { taken_slugs }
      subject.send(:fill_in_slug).should eq('home-4')
    end
  end

  describe '#fill_in_slug' do
    it "fills the slug" do
      subject.title = 'home'
      subject.send(:fill_in_slug).should eq('home')
    end
  end

  describe '#regenerate_permalink' do
    before { subject.slug = 'slug' }

    context 'for root' do
      it "returns /" do
        subject.send(:regenerate_permalink)
        subject.permalink.should eq('/')
      end
    end
    context "with one parent" do
      it "returns the permalink of one level, excluding the root slug" do
        subject.stub(:root?) { false }
        subject.stub(:parent) { parent }
        subject.send(:regenerate_permalink)
        subject.permalink.should eq('/slug')
      end
    end
    context "with two parents" do
      it "returns the permalink with two levels" do
        subject.stub(:root?) { false }
        subject.stub(:parent) { parent }
        parent.stub(:root?) { false }
        parent.stub(:parent) { grandparent }
        subject.send(:regenerate_permalink)
        subject.permalink.should eq('/parent/slug')
      end
    end
  end
end
