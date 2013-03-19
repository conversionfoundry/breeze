require 'spec_helper'

feature "Manage content types in Admin panel" do
  let!(:content_type) { Fabricate :content_type }

  background do
    sign_in
  end

  scenario "list existing content types" do
    visit admin_custom_types_path
    expect(page).to have_content(content_type.name)
  end

  scenario "create a content type" do
    visit admin_custom_types_path
    click_link "New custom type"
  end

end
