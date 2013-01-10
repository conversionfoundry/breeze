require 'spec_helper'

describe Breeze::Content::Custom::Type do
  subject { Fabricate.build :custom_type }
  let(:custom_field) { Fabricate.build :custom_field }
  let(:custom_field_2) { Fabricate.build :custom_field }

  describe 'validations' do
    it { should be_valid }

    # it { should validate_presence_of :type_name }
    # it { should validate_uniqueness_of :type_name }
    it { should validate_presence_of :name }
    # it { should validate_uniqueness_of :name }
    
    it "validates name format" do
      subject.name = 'custom/type (28%)'
      subject.valid?
      subject.should have(1).error_on(:name)
    end
  end

  it "has a camelcased type name" do
    subject.valid?
    subject.type_name.should eq("FancySlider")
  end

  it "exposes a default template name" do
    subject.name = 'custom_type_1'
    subject.save
    subject.default_template_name.should eq('custom_type1')
  end

end
