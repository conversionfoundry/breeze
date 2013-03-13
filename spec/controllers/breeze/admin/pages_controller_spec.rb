require 'spec_helper'


describe Breeze::Admin::PagesController do

  let!(:pag) { Fabricate(:page) }
  let(:user) { Fabricate(:user) }

  before do
    @routes = Breeze::Engine.routes
    sign_in user
  end

  describe "POST #duplicate" do
    it "returns ok" do
      post :duplicate,
        id: pag.id
      response.status.should eq(201)
    end

    it "should assigns the new page" do
      post :duplicate,
        id: pag.id
      assigns(:page).should be_a(Breeze::Content::Page)
    end
  end

end
