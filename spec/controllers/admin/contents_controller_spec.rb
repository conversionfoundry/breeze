require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")


describe Breeze::Admin::ContentsController do 

  let(:page) { Fabricate(:page) }


  describe "#load_container_and_placement" do
    before do
      controller.stub(:params).and_return({id: page.placements.first.id})
      controller.send(:load_container_and_placement)
    end

    it "assigns @container" do
      assigns(:container).should eq(page)
    end

    it "assigns @placement" do
      assigns(:placement).should eq(page.placements.first)
    end
  end


  describe "POST duplicate" do
    before do
      post :duplicate, id: page.placements.first.id, use_route: :breeze
    end

    it "assigns @old_placement" do
      assigns(:old_placement).should eq(page.placements.first)
    end
  end

end
