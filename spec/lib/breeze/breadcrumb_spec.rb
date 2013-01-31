require 'spec_helper'

describe Breeze::Breadcrumb do
  let(:page) { Fabricate :page  }
  let(:child_page) { Fabricate :page, parent: page  }
  let(:divider) { '&gt;' }
  
  context "with no parents"  do
    subject { Breeze::Breadcrumb.new(for_page: page, divider: divider) }
    it "displays nothing for the root page" do
      subject.generate.should == nil 
    end
    it "does not display the divider" do
      subject.generate.should_not =~ %r{class="divider"}
    end
  end

  context "with parents"  do
    subject { Breeze::Breadcrumb.new(for_page: child_page, divider: divider) }
    it "displays the name of the current page for a child page" do
      subject.generate.should =~ %r{#{child_page.title}} 
    end
  end  
end
