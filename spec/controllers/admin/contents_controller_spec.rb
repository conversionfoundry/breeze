require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

class ContainerTest < Breeze::Content::Item
  include Breeze::Content::Mixins::Container 
end

describe Breeze::Admin::ContentsController do 

  let(:page) { Fabricate(:page) }
  let(:container) { ContainerTest.create } 

  describe "GET #add" do
    # This is actually probably the job of the GET #new, merge and verify
  end
  
  describe "GET #new" do
    # Idenfify where it is called in the code
  end

  describe "POST #duplicate" do
    before do
      post :duplicate, id: page.placements.first.id, use_route: :breeze
    end

    it "assigns @old_placement" do
      assigns(:old_placement).should eq(page.placements.first)
    end

    it "assigns @placement"
    it "assigns @view"
  end

  describe "GET #search" do
    # get :search, id: container.id
  end

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

end
