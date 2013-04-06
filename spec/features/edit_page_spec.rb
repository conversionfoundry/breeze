require 'spec_helper'

feature 'Edit a page in the front end' do
  let!(:p) { Fabricate :page } #homepage

  background do
    sign_in
  end
  
  scenario "adds some text in the first region and saves", js: :true, focus: true do
    visit root_path
    toggle_editor
    header_region.click_link('+')
    left_menu.should have_content('Snippet')
  end

end
