require 'spec_helper'

feature 'plays nice with content types' do
  let!(:p) { Fabricate :page } #homepage
  let!(:ct) { Fabricate :content_type }
  let!(:gallery) { Fabricate :gallery }

  background do
    sign_in
    visit root_path
    toggle_editor
    header_region.click_link('+')
  end

  scenario "displays a list of available content type", js: :true do
    left_menu.should have_content('content type')
    left_menu.should have_content('gallery')
  end

  scenario "displays fields associated to the selected content type" do
    
  end

end


# test the specific fields are the good ones 
# test the flash message
# test the page has the content
