module PageSteps
  rspec type: :feature

  def toggle_editor
    find("breeze-toolbar-edit-button").click_link("Toggle editor")
  end

  def page_header_region
    find("page_header_region")
  end

  #left hand side 
  def lhs_menu
  end
  
end
