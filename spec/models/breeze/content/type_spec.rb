require 'spec_helper'

describe Breeze::Content::Type do

  let(:subject) do
    Breeze::Content::Type.new(name: 'snippet')
  end

  it { should be_valid }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_format_of(:name).not_to_allow("7&!") }

    it { should validate_uniqueness_of(:type_name) }
    it { should validate_format_of(:type_name).not_to_allow(:type_name) }

    it "fills the type name" do
      subject.type_name.should be_nil
      subject.valid?
      subject.type_name.should_not be_nil
    end
  end

  describe "associations" do
    it { should embed_many(:fields) }
  end


  describe "#fill_in_type_name" do
    it "camelcase the name to set the typename" do
      subject.valid?
      subject.type_name.should eq("Snippet")
    end
  end

end
