require 'spec_helper'

describe Breeze::Content::Type do

  describe "validations" do
    it { should validate_presence_of(:type_name) }
    it { should validate_uniqueness_of(:type_name) }

    it { should validate_uniqueness_of(:name) }
  end

end
