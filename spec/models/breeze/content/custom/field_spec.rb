require 'spec_helper'


describe Breeze::Content::Custom::Field do 

  subject do
    Breeze::Content::Custom::Field.new
  end

  describe 'validations' do
    it "should not allow symbols for the name" do
      subject.name = "%dwawd !!"
      subject.should have(1).error_on(:name)
    end
  end

end

