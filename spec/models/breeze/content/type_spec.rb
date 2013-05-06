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
  end

  describe "associations" do
    it { should embed_many(:content_fields) }
  end

  describe "#template_name" do
    it "parameterize the name file" do
      subject.name = "Unique selling point 20%"
      subject.template_name.should eq("unique-selling-point-20")
    end
  end

  describe "#after_create" do
    it "creates a partial with the type name" do
      FileTest.exists?(subject.partial_path).should be_true
    end
  end

  describe "#content_fields_names" do
    it "returns empty array if no fields are present" do
      subject.content_fields_names.should eq([])
    end

    it "returns an array of names if some fields are presents" do
      subject.stub(:content_fields) do
        [double(name: 'one'), double(name: 'two')]
      end
      subject.content_fields_names.should eq(['one', 'two'])
    end
  end

end
