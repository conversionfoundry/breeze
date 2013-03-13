require 'spec_helper'

feature "Manage pages in Admin panel" do
  let!(:p) { Fabricate :page }
  # let!(:p2) { Fabricate :page }

  background do
    sign_in # see session helper
  end


  scenario "create a page", focus: true do
    visit admin_pages_path
    click_link "New page"
  end

  scenario "list all the pages" do
    visit admin_pages_path
    expect(page).to have_content("Home")
    # expect(page).to have_content(p2.permalink)
  end

  scenario "duplicate a page", js: :true do
    visit admin_pages_path
  end

end

