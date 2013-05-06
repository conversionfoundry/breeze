require 'spec_helper'

describe Breeze::Admin::ContentTypeInstancesController do

  let(:user) { Fabricate(:user) }
  let(:pag) { Fabricate(:page) }
  let!(:typ) { Fabricate(:content_type) }
  

  before do
    sign_in user
  end

  # The request for this action typically
  # var url = '/admin/content_type_instances/new?content[page_id]=' +
  # breeze.options.page_id + '&content[region]=' +
  # $(this).closest('.breeze-editable-region').attr('data-region');
  describe "#new" do
    it "returns ok" do
      get :new,
        content: { page_id: pag.id, region: :header },
        format: :js
      response.status.should eq(200)
    end
  end

  describe "#create" do
    it "returns ok" do
      post :create,
        content_type_instance: { 
          region: :header, 
          page_id: pag.id, 
          content_type_id: typ.id, 
          content: { title: 'wat' }
        },
        format: :js
      response.status.should eq(200)
    end
  end

end
