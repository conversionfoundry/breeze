module EditPage
  rspec type: :feature

  def toggle_editor
    page.execute_script("$('#breeze-toolbar').css('top','1px')")
    within('#breeze-toolbar') do
      first(:link, "Edit").click #TODO solve offscreen problem
    end
  end
  
  def header_region
    find('#page_header_region')
  end


end
