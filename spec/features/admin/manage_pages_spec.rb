require 'spec_helper'

feature "Manage pages in Admin panel" do
  let!(:p) { Fabricate :page } # Homepage
  # let!(:p2) { Fabricate :page }

  background do
    sign_in # see session helper
  end

  scenario "create a page",js: true, focus: true do
    visit admin_pages_path
    click_link "New page"
    fill_in("page_title", with: "Landing page")
    save_and_open_page
    click_button "OK"
    within "#pages" do
      expect(page).to have_content("Landing page")
    end
  end

  scenario "list all pages" do
    visit admin_pages_path
    expect(page).to have_content("Home")
    # expect(page).to have_content(p2.permalink)
  end

  scenario "view a page" do
    #TODO
  end

  scenario "edit a page" do
    #TODO
  end

  scenario "duplicate a page", js: :true do
    #TODO
  end

  scenario "delete a page" do
    #TODO
  end

end

