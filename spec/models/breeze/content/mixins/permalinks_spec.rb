require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

class PermalinkTest < Breeze::Content::Item
  field :title
  belongs_to :parent, class_name: PermalinkTest
  include Breeze::Content::Mixins::Permalinks
  include Breeze::Content::Mixins::TreeStructure
end

describe "Permalink" do
  let(:root) { PermalinkTest.create(slug: 'home') }
  let(:parent) { PermalinkTest.create(slug: 'parent', parent: root) }
  subject { PermalinkTest.create(title: 'children', parent: parent) }

  let(:taken_slugs) { %w(children children-2 children-3) }

  it { should be_valid }

  describe '#fill_in_slug' do
    it "fills the slug" do
      subject.title = 'home'
      subject.send(:fill_in_slug).should eq('children')
    end

    it "generates the next available slug" do
      Breeze::Content::Mixins::Permalinks::SlugGenerator.any_instance.stub(:taken_slugs) { taken_slugs }
      subject.send(:fill_in_slug).should eq('children-4')
    end
  end

  describe '#regenerate_permalink' do
    before { subject.slug = 'slug' }

    context 'for root' do
      it "returns /" do
        root.send(:regenerate_permalink)
        root.permalink.should eq('/')
      end
    end
    context "with one parent" do
      it "returns the permalink of one level, excluding the root slug" do
        parent.send(:regenerate_permalink)
        parent.permalink.should eq('/parent')
      end
    end
    context "with two parents" do
      it "returns the permalink with two levels" do
        subject.send(:regenerate_permalink)
        subject.permalink.should eq('/parent/slug')
      end
    end
  end

  describe "#update_child_permalinks" do
    it "update children permalinks" do
      parent.slug = "modifiedparent"
      parent.save
      subject.permalink.should eq('/modifiedparent/children')
    end
  end
end
