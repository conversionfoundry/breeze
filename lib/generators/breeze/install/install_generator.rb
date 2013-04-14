require 'rails/generators'

module Breeze
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.join(File.dirname(__FILE__), "templates")
      end

      def install_breeze
        raise "MODIFY ME"
# 
#         # Add to config/routes
#         log "", "Mounting Breeze engine in config/routes"
#         route("mount Breeze::Engine, :at => '/'")
# 
#         if File.exist?(Rails.root.to_s + '/public/index.html')
#           log "", "Removing Rails default static index.html file"
#           File.delete(Rails.root.to_s + '/public/index.html')
#         end
# 
#         # Create a theme with the same name as the app
#         unless Breeze::Configuration.first && Breeze::Configuration.first.themes.where(name: "install_test").any?
#           theme_name = File.basename(Rails.root)
#           log "", "Creating directories for " + theme_name + " theme..."
#           generate 'breeze:theme', theme_name
#           theme = Breeze::Theming::Theme[theme_name]
#           theme.enable!
#         end
# 
#         # Create placeholder custom type
#         unless Breeze::Content::Custom::Type.where(name: 'Content Placeholder').any?
#           log "", "Creating placeholder custom type..."
#           placeholder = Breeze::Content::Custom::Type.create! name: 'Content Placeholder'
#           placeholder.custom_fields.build({ name: 'placeholder_content', label: 'Content', position: 0, _type: 'Breeze::Content::Custom::TextField'})
#           placeholder.save
#         end
# 
#         # Create contact_form custom type
#         unless Breeze::Content::Custom::Type.where(name: 'Contact Form').any?
#           log "", "Creating contact_form custom type..."
#           contact_form = Breeze::Content::Custom::Type.create! name: 'Contact Form'
#           contact_form.custom_fields.build({ name: 'title', label: 'Title', position: 0, _type: 'Breeze::Content::Custom::StringField'})
#           contact_form.custom_fields.build({ name: 'body_before_form', label: 'Body Before Form', position: 1, _type: 'Breeze::Content::Custom::TextField'})
#           contact_form.custom_fields.build({ name: 'body_after_form', label: 'Body After Form', position: 2, _type: 'Breeze::Content::Custom::TextField'})
#           contact_form.custom_fields.build({ name: 'confirmation_message', label: 'Confirmation message', position: 3, _type: 'Breeze::Content::Custom::TextField'})
#           contact_form.save
#         end
# 
#         # Create root page
#         unless Breeze::Content::Page.where(title: "Home").any?
#           log "", "Creating Home page..."
#           home = Breeze::Content::Page.create! :title => "Home"
# 
#           # Create a snippet with a welcome message
#           s = Breeze::Content::Snippet.create! :content => "<h1>Welcome to Breeze!</h1>"
#           home.placements << Breeze::Content::Placement.new( :region => 'above_content', :content => s )
#         end
# 
#         # Create Contact Us page
#         unless Breeze::Content::Page.where(title: "Contact Us").any?
#           log "", "Creating Contact Us page..."
#           home = Breeze::Content::Page.first
#           contact_us = Breeze::Content::Page.create! title: "Contact Us", parent: home
# 
#           # Create a contact_form
#           cf = Breeze::Content::ContactForm.create! title: "Contact Us", body_before_form: "We'd love to hear from you.", body_after_form: "We usually respond within 24 hours.", confirmation_message: "Thanks! We'll be in touch."
#           contact_us.placements << Breeze::Content::Placement.new( :region => 'column_middle', :content => cf )
#         end
#       
#         # Create emergency user
#         if Breeze::Admin::User.where(:email => 'emergency@example.com').count == 0
#           log "", "Creating admin user..."
#           Breeze::Admin::User.create :first_name => "Emergency", :last_name => "User", :email => "emergency@example.com", :password => "logmein", :password_confirmation => "logmein", :roles => [ :admin ]
#         end
# 
#         # Prompt for new password
# 
#         # Print instructions for logging in 
#         log "", "Breeze is ready. Log in at [address goes here] with username 'emergency' and password 'logmein'"

      end
    end
  end
end
