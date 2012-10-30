require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

class PermalinkTest < Breeze::Content::Item
  field :title
  belongs_to :parent, class_name: PermalinkTest
  include Breeze::Content::Mixins::Permalinks
end

describe "Permalink" do
  subject { PermalinkTest.new }
  let(:taken_slugs) { %w(home home-2 home-3) }

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

  describe '#regenerate_permalink!' do
    before { subject.slug = 'slug' }

    context 'with no parents' do
      it "should returns /slug" do
        subject.regenerate_permalink!
        subject.permalink.should eq('/slug')
      end
    end

    context "with parents" do
      it "should give a well formed slug" do
        subject.stub_chain(:parent, :permalink) { '/parent' }
        subject.regenerate_permalink!
        subject.permalink.should eq('/parent/slug')
      end
    end
  end
end
