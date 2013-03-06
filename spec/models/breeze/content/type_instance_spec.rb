require 'spec_helper'

describe Breeze::Content::TypeInstance do

  describe "validations" do
    it { should validate_presence_of(:region) }
  end

end
