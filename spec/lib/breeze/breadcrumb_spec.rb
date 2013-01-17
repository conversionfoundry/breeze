require 'spec_helper'

describe Breeze::Breadcrumb do
  let(:page) { Fabricate :page  }
  let(:divider) { '&gt;' }
  subject { Breeze::Breadcrumb.new(for_page: page, divider: divider) }
  
  it "displays the name of the current page" do
    subject.generate.should =~ %r{#{page.title}} 
  end

  context "with no parents"  do
    it "does not display the divider" do
      subject.generate.should_not =~ %r{class="divider"}
    end
  end
  
end
