require 'spec_helper'

describe Breeze::ContentsController do
  let!(:pag) do 
    Fabricate :page 
  end

  describe 'GET #show' do
    
    it "renders a default template" do
      pag.update_attribute(:permalink, '/super-page')
      get :show, permalink: 'super-page' 
      response.should render_template(:visitor)
    end

  end
  
end
