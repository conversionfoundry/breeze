require 'spec_helper'

feature "Manage pages in Admin panel" do
  # let!(:p) { Fabricate :page } # Homepage
  # let!(:p2) { Fabricate :page }

  background do
    sign_in # see session helper
  end

  scenario "create a page", js: true, focus: true do
    visit admin_pages_path
    click_link "New page"
    fill_in("page_title", with: "Presentation page")
    click_button "OK"
    require 'pry'; binding.pry
    within "#pages" do
      expect(page).to have_content("Presentation page")
    end
  end

  scenario "list all pages" do
    visit admin_pages_path
    within "#left" do
      expect(page).to have_content("Home")
    end
  end

  scenario "show a page" do
    visit admin_pages_path
    within "#left" do
      click_link "Home"
    end
    within "#main" do
      expect(page).to have_content("Edit landing page")
    end
  end

  scenario "edit a page" do
    visit admin_pages_path
    within "#left" do
      click_link "Home"
    end
    within "#main" do
      #TODO
    end
  end

  scenario "duplicate a page", js: :true do
    #TODO
  end

  scenario "delete a page" do
    #TODO
  end

end

