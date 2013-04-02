require 'spec_helper'

feature 'Edit a page in the front end' do

  background do
    Fabricate :page
    sign_in
  end
  
  scenario "adds some text in the first region and saves", js: true do
    visit root_path
    # require 'pry'; binding.pry
    toggle_editor
    page_header_region.click_link('+')
  end

end
