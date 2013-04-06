module CreationSteps
  rspec type: :feature

  def create_content_type
    visit admin_custom_types_path
    click_link "New custom type"
    fill_in "custom_type_name", with: 'dialogbox'
    fill_in "type_content_fields_attributes_0_label", with: 'title'
    fill_in "type_content_fields_attributes_0_name", with: 'name'
    click_link "Add another field"
    fill_in "type_content_fields_attributes_1_label", with: 'title 1'
    fill_in "type_content_fields_attributes_1_name", with: 'name 1'
    click_button "Save"
  end

end
