module PageSteps
  rspec type: :feature

  def toggle_editor
    click_link("css=a[title='Toggle editor']")
  end

  def page_header_region
    find("page_header_region")
  end

  #left hand side 
  def lhs_menu
  end
  
end
