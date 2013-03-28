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

  describe "#default_template_name", focus: true do
    it "parameterize the name file" do
      subject.name = "Unique selling point 20%"
      subject.default_template_name.should eq("unique-selling-point-20")
    end
  end

end
