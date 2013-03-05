require 'spec_helper'


describe Breeze::Admin::PagesController do

  let!(:pag) { Fabricate(:page) }

  before do
    @routes = Breeze::Engine.routes
  end

  describe "POST #duplicate" do
    it "returns ok" do
      post :duplicate,
        id: pag.id
      response.code.should eq('302')
    end

    it "should assigns the new page" do
      post :duplicate,
        id: pag.id
      assigns[:page].should_not be_nil
    end
  end

end
