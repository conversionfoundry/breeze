require File.expand_path(File.dirname(__FILE__) + "/../../../../spec_helper")

describe "TreeStructure" do

  let(:parent) { Fabricate :page}
  subject { Fabricate :page, parent: parent }
  let(:target) { Fabricate :page, parent: parent, title: 'target', slug: 'target' }

  describe "#set_position" do
    context "children of a parent item" do
      context "first child" do
        it "has position 0" do
          subject.position.should eq 0
        end
      end
      context "second child" do
        it "has position 1" do
          subject
          second_child = Fabricate :page, parent: parent
          second_child.position.should eq 1
        end
      end
    end
  end

  describe "#move_before!" do
    before :each do
      subject.position = 2
      subject.save
      subject.move!(:before, target.id)
    end
    # it "has same parent as target" do
    # 	subject.parent.should eq target.parent
    # end
    it "has position immediately before target's position" do
      target.reload
      subject.position.should eq ( target.position - 1 )
    end
    # it "calls update_sibling_position with the correct ref_position"
  end

  describe "#move_after!" do
    before :each do
      subject.move!(:after, target.id)
    end
    it "has same parent as target" do
      subject.parent.should eq target.parent
    end
    it "has position immediately after target's position" do
      target.reload
      subject.position.should eq ( target.position + 1 )
    end
    # it "calls update_sibling_position with the correct ref_position"
  end

  describe "#move_inside!" do
    let!(:target_child) { Fabricate :page, parent: target, title: 'target_child', slug: 'target_child' }
    before :each do
      subject.move!(:inside, target.id)
    end  	
    it "has target as parent" do
      subject.parent.should eq target
    end
    it "has position immediately after target_child" do
      subject.position.should eq ( target_child.position + 1 )
    end
    # it "calls update_sibling_position with the correct ref_position"
  end

  describe "update sibling positions" do
    # it "has no sibling with the same position"
  end

end
