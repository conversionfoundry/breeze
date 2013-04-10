require 'spec_helper'

feature "Manage content types in Admin panel" do
  given!(:content_type) { Fabricate(:content_type, name: 'usp') }
  given!(:another_content_type) { Fabricate(:content_type, name: 'gallery') }

  background do
    sign_in # See spec/support/features/session_helpers.rb
  end

  scenario "list existing content types" do
    visit admin_custom_types_path
    expect(page).to have_content(content_type.name)
    expect(page).to have_content(another_content_type.name)
  end

  scenario "create a content type", js: true, focus: true do
    expect do
      create_content_type
    end.to change { Breeze::Content::Type.count }.by(1)
  end

  scenario "edit a content type", js: true do
    visit admin_custom_types_path
    click_link 'usp'
    within('#main-tabs-content') do
      expect(page).to have_content('usp')
    end
  end

end
