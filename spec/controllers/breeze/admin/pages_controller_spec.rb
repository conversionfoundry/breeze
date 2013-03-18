require 'spec_helper'


describe Breeze::Admin::PagesController do

  let(:page_attributes) { Fabricate.attributes_for(:page) }
  let!(:pag) { Breeze::Content::Page.create(page_attributes) }
  let(:user) { Fabricate(:user) }

  before do
    sign_in user
  end

  describe "GET #edit" do
    context "when exists" do
      it "returns ok" do
        get :edit,
          id: pag.id
        assigns(:page).title.should eq("my_super_page")
        response.status.should eq(200)
      end
    end
    # TODO spec the exception returned
    # context "when does not exists" do
    #   it "returns whatever" do
    #     get :edit,
    #       id: 'wat'
    #     # response.status.should eq(404)
    #   end
    # end
  end

  #TODO spec also the activity log
  describe "Post #create" do
    it "returns 202 #created" do
      post :create,
        page: page_attributes
      response.status.should eq(202)
    end
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

  describe "PUT #update" do
    it "returns ok" do
      put :update,
        id: pag.id,
        page: page_attributes.merge(subtitle: "updated subtitle"),
        format: :js
      response.should render_template('update')
      response.status.should eq(200)
    end
  end

end
