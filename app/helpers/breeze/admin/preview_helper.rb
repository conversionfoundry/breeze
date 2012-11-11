#require 'capybara'
#require 'capybara/dsl'

#Capybara.default_driver = :webkit
#Capybara.javascript_driver = :webkit
#Capybara.app_host = Rails.root.join("tmp")

#module Breeze
  #module Admin
    #class PreviewHelper
    #include Capybara::DSL

    #def screenshot(controller, request)
      #home = Breeze::Content::Page.where(:permalink => "/").first
      #class << controller
        #attr_accessor :view  
      #end  
      #request.format = "html"
      #a = home.render(controller, request)
      #File.open(Rails.root.join("tmp/test.html"), 'w') {|f| f.write(a.first) }
      #Capybara.app_host = Rails.root.join("tmp")
      #visit('test.html')
      #page.driver.render "tmp/screenshot.png"
      
      

    #end
    #end
  #end
#end

