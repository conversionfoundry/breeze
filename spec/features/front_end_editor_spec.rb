require 'spec_helper'

feature "Front End Edition", :type => :request do
  background do
    Fabricate(:page)
  end

  scenario "as an editor it inserts editing controls into the page" do
    sign_in
    visit root_path
    page.body.should include('<body>')
    page.body.should include("<div class='editor-panel'>")
  end

  scenario "as a visitor it doesn't insert editing controls into the page" do
    visit root_path
    page.body.should include('<body>')
    page.body.should_not include("<div class='editor-panel'>")
  end
end
