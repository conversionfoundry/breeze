require 'spec_helper'

describe Breeze::Content::Custom::Type do
  subject { Fabricate.build :custom_type }
  let(:custom_field) { Fabricate.build :custom_field }
  let(:custom_field_2) { Fabricate.build :custom_field }

  describe 'validations' do
    it { should be_valid }
    it { should validate_presence_of :type_name }
    it { should validate_uniqueness_of :type_name }
    # it { should validate_presence_of :name }
    # it { should validate_uniqueness_of :name }
    # it { should_not allow_value('notcamelcased').for(:type_name)}
  end

  # 
  # describe "when defined" do
  #   before :each do
  #     @custom_type = Breeze::Content::Custom::Type.create :name => "fancy box", :custom_fields => [ Breeze::Content::Custom::Field.new(:name => :title), Breeze::Content::Custom::Field.new(:name => :content) ]
  #   end
  #   
  #   it "should have a proper constant name" do
  #     @custom_type.type_name.should == "FancyBox"
  #   end
  #   
  #   it "should know how to be a class" do
  #     @custom_type.to_class.should be_a(Class)
  #   end
  #   
  #   it "should be accessible from the Content module" do
  #     Breeze::Content::FancyBox.should be_a(Class)
  #   end
  #   
  #   it "should define itself as a constant" do
  #     Breeze::Content::FancyBox.should be_a(Class)
  #     Breeze::Content.const_defined?(:FancyBox).should == true
  #   end
  #   
  #   it "should define fields on the class" do
  #     Breeze::Content::FancyBox.fields.keys.should include(*%w(title content))
  #   end
  #   
  #   it "should be able to create new instances" do
  #     Breeze::Content::FancyBox.new.should be_a(Breeze::Content::FancyBox)
  #   end
  #   
  #   it "should define fields on the instances" do
  #     Breeze::Content::FancyBox.new.should respond_to(:content)
  #   end
  #   
  #   describe "and updated" do
  #     before :each do
  #       @custom_type.custom_fields << Breeze::Content::Custom::Field.new(:name => :tags)
  #       @custom_type.save!
  #     end

  #     it "should undefine the constant" do
  #       Breeze::Content.const_defined?(:FancyBox).should == false
  #     end

  #     it "should update the class" do
  #       Breeze::Content::FancyBox.fields.keys.should include(*%w(title content tags))
  #     end
  #   end
  # end
end
