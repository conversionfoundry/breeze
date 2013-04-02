require 'spec_helper'

feature "Manage pages in Admin panel" do
  let!(:p) { Fabricate :page } # Homepage
  # let!(:p2) { Fabricate :page }

  background do
    sign_in # see session helper
  end

  scenario "create a page", js: true do
    visit admin_pages_path
    click_link "New page"
    fill_in("Title", with: "Presentation page")
    click_button "OK"
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

  scenario "show a page", js: true do
    visit admin_pages_path
    within "#left" do
      click_link "Home"
    end
    within "#main" do
      expect(page).to have_content("Edit #{p.title}")
    end
  end

  scenario "edit a page", js: true do
    visit admin_pages_path
    within "#left" do
      click_link "Home"
    end
    within "#main" do
      fill_in "content_page_title", with: "career"
    end
    click_button "Save"
    visit admin_pages_path
    within "#left" do
      click_link "Home"
    end
    expect(page).to have_content("career")
  end

  scenario "duplicate a page", js: :true do
    #TODO Capybara does not support right-click.
  end

  scenario "delete a page" do
    #TODO Capybara does not support right-click.
  end

end

