require 'spec_helper'

describe "Front End Editor", :type => :request do

  before :each do
  end

  context "User logged in" do
    before :each do
      user = Fabricate :user
      page.driver.header("USER_AGENT", "capybara")
      visit "/admin"
      within "#sign_in #new_admin" do
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => user.password
        click_button 'Sign in'
      end
    end

    it "Inserts editing controls into the page" do
      home_page = Fabricate :page

      visit "/"
      page.body.should include('<body>')
      page.body.should include("<div class='editor-panel'>")
    end
  end

  context "No user logged in" do
    it "Doesn't insert editing controls into the page" do
      home_page = Fabricate :page
      visit "/"
      page.body.should include('<body>')
      page.body.should_not include("<div class='editor-panel'>")
    end
  end
end
