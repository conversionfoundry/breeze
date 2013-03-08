require 'spec_helper'


describe Breeze::Content::Custom::Field do 

  subject do
    Breeze::Content::Custom::Field.new(label: 'Title')
  end

  it { should be_valid }

  describe 'validations' do
    it { should validate_presence_of(:label) }
    it { should validate_format_of(:name).not_to_allow("%dwawd !!") }
  end

  describe "associations" do
    it { should be_embedded_in(:type).as_inverse_of(:fields) }
  end

  describe "#fill_in_name" do
    it "fills the name properly" do
      subject.name.should be_nil
      subject.valid?
      subject.name.should eq('title')
    end
  end

end

