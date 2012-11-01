require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

class PermalinkTest < Breeze::Content::Item
  field :title
  belongs_to :parent, class_name: PermalinkTest
  include Breeze::Content::Mixins::Permalinks
  include Breeze::Content::Mixins::TreeStructure
end

describe "Permalink" do
  subject { PermalinkTest.new }
  let(:taken_slugs) { %w(home home-2 home-3) }
  let(:parent) { PermalinkTest.new }
  let(:grandparent) { PermalinkTest.new }

  describe "#generate_slug(default_slug, *taken_slugs)" do
    it "generates the next available slug" do
      subject.send(:generate_slug, 'home', *taken_slugs).should eq('home-4')
      subject.send(:generate_slug, 'home', *[]).should eq('home-2')
    end
  end

  describe '#fill_in_slug' do
    it "fills the slug" do
      subject.title = 'home'
      subject.send(:fill_in_slug).slug.should eq('home')
    end
  end

  describe '#regenerate_permalink' do
    before { subject.slug = 'slug' }

    context 'for root' do
      it "returns /" do
        subject.regenerate_permalink
        subject.permalink.should eq('/')
      end
    end
    context "with one parent" do
      it "returns /parent/slug" do
        subject.stub(:root?) { false }
        subject.stub(:parent) { parent }
        parent.stub(:slug) { 'parent' }
        subject.regenerate_permalink
        subject.permalink.should eq('/parent/slug')
      end
    end
    context "with two parents" do
      it "returns /grandparent/parent/slug" do
        subject.stub(:root?) { false }
        subject.stub(:parent) { parent }
        parent.stub(:slug) { 'parent' }
        parent.stub(:root?) { false }
        parent.stub(:parent) { grandparent }
        grandparent.stub(:slug) { 'grandparent' }
        subject.regenerate_permalink
        subject.permalink.should eq('/grandparent/parent/slug')
      end
    end
  end
end
