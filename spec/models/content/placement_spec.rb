require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

class PlacementTestContainer < Breeze::Content::Item
  include Breeze::Content::Mixins::Container
end

class PlacementTestContent < Breeze::Content::Item
  include Breeze::Content::Mixins::Placeable
end

describe Breeze::Content::Placement do
  before :each do
    PlacementTestContainer.collection.drop
    PlacementTestContent.collection.drop
    
    @container = PlacementTestContainer.create
    @container.should be_valid
    @container.should_not be_new_record
    @container.placements.should be_empty
    
    @content = PlacementTestContent.create
    @content.placements_count.should be_zero
    @content.should be_valid
    @content.should_not be_new_record

    @placement = @content.add_to_container @container, "default", "default"
    @container.placements.count.should == 1
    @container.save
  end
  
  it "should update its contents' placements_count" do
    @content.reload.placements_count.should == 1
  end
  
  it "should be destroyed when its content is destroyed" do
    @content.destroy
    @container.reload
    @container.placements.should be_empty
  end
  
  describe "when destroyed" do
    before :each do
      @placement.destroy
    end
    
    it "should delete its content" do
      PlacementTestContent.count.should be_zero
    end
  end
  
  describe "when duplicated" do
    before :each do
      @new_placement = @placement.duplicate
      @container.reload
      @placement = @container.placements.by_id @placement.id
      @content = @placement.content
      @new_placement = @container.placements.by_id @new_placement.id
    end
    
    it "should not duplicate its content" do
      @placement.content_id.should == @new_placement.content_id
      PlacementTestContent.count.should == 1
    end
    
    it "should be a separate placement in the container" do
      @container.placements.count.should == 2
    end
    
    it "should be positioned directly after the old placement" do
      @new_placement.position.should == @placement.position + 1
    end
    
    describe "and destroyed" do
      before :each do
        @new_placement.destroy
      end

      it "should not delete its content" do
        PlacementTestContent.count.should == 1
      end

      it "should decrement its content's placements_count" do
        @content.reload
        @content.placements_count.should == 1
      end
    end
    
    describe "and unlinked" do
      before :each do
        @new_placement.unlink!
        @container.reload
        @placement = @container.placements.by_id @placement.id
        @content = @placement.content
        @new_placement = @container.placements.by_id @new_placement.id
        @new_content = @new_placement.content
      end
      
      it "should create a new piece of content" do
        PlacementTestContent.count.should == 2
        @placement.content_id.should_not == @new_placement.content_id
      end
      
      it "should decrement the placements_count for the old content" do
        @content.placements_count.should == 1
      end
      
      it "should set the placements_count for the new content to 1" do
        @new_content.placements_count.should == 1
      end
      
      describe "and destroyed" do
        before :each do
          @new_placement.destroy
        end

        it "should delete its content" do
          PlacementTestContent.count.should == 1
        end
      end
    end
  end
end