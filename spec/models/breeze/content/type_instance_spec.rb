require 'spec_helper'

describe Breeze::Content::TypeInstance do

  describe "validations" do
    it { should validate_presence_of(:region) }
  end

  describe "#respond_to?" do
    it "looks among the allowed dynamic accessors" do
      subject.stub(:allowed_dynamic_accessors) { [:bar, :fuu] }
      subject.respond_to?(:fuu).should be_true
    end
  end

  # Lets describe a dynamic method
  describe "#foo" do
    it "returns the value of the attribute" do
      subject.stub(:allowed_dynamic_accessors) { [:bar, :foo] }
      subject.bar.should eq(nil)
    end
  end

  # One method not allowed
  describe "#fuubar" do
    it "returns one exception" do
      subject.stub(:allowed_dynamic_accessors) { [] }
      expect { subject.fuubar }.to raise_error
    end
  end


end
