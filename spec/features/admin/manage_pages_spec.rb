require 'spec_helper'

feature "Manage pages in Admin panel" do
  let!(:p) { Fabricate :page }

  background do
    sign_in # see session helper
  end

  scenario "can list all the pages" do
    visit admin_pages_path
    expect(page).to have_content(p.title)
  end

end

