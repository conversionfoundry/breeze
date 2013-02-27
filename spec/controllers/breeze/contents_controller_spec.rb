require 'spec_helper'

describe Breeze::ContentsController do
  let!(:page) do 
    Fabricate :page do |p|
      p.permalink = '/super_page'
      p.template = 'home'
    end
  end

  describe 'GET #show' do
    before do
      @routes = Breeze::Engine.routes
    end
    
    it "renders a default template" do
      get :show, permalink: page.permalink
      response.should render_template(:page)
    end
  end
  
end
