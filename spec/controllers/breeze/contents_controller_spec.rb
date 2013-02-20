require 'spec_helper'


describe Breeze::ContentsController do

  describe 'GET #show' do
    it "renders a default template" do
      get :show, permalink: '/nice-page'
      it { should render_template(:page) }
    end
  end
  
end
