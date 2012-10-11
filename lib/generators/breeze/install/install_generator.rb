require 'rails/generators'

module Breeze
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.join(File.dirname(__FILE__), "templates")
      end

      def install_breeze

        in_root do
          inside "public" do
            if !File.exists?("breeze")
              log "", "Creating symlinks..."
              run extify("ln -s ../vendor/plugins/breeze/public breeze") # TODO: Not sure why we need this link - Isaac
            end
          end
        end

        # Create a theme with the same name as the app
        theme_name = File.basename(Rails.root)
        log "", "Creating directories for " + theme_name + " theme..."
        generate 'breeze:theme', theme_name

        # Create root page
        if Breeze::Content::Page.count == 0
          log "", "Creating home page..."
          home = Breeze::Content::Page.create! :title => "Home"

          # Create a snippet with a welcome message
          # TODO: There should be a method for pages to make this simpler.
          s = Breeze::Content::Snippet.create! :content => "<h1>Welcome to Breeze!</h1>"
          home.placements << Breeze::Content::Placement.new( :region => 'sidebar', :content => s )
        end


        
        # Create emergency user
        if Breeze::Admin::User.where(:email => 'emergency@example.com').count == 0
          log "", "Creating admin user..."
          Breeze::Admin::User.create :first_name => "Emergency", :last_name => "User", :email => "emergency@example.com", :password => "logmein", :password_confirmation => "logmein", :roles => [ :admin ]
        end

        # Print instructions for logging in 
        log "", "Breeze is ready. Log in at [address goes here] with username 'emergency' and password 'logmein'"

      end
    end
  end
end
