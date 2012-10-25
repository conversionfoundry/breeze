require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

class PlaceableTest < Breeze::Content::Placement
  include Breeze::Content::Mixins::Placeable
end


describe PlaceableTest do
  subject { Fabricate :snippet }
  let(:container) { Fabricate :page }

  describe "#duplicate" do
    it "returns false if something is missing" do
      subject.duplicate(container).should be_false
    end
  end
end
