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
              run extify("ln -s ../vendor/plugins/breeze/public breeze")
            end
          end
        end
      end
    end
  end
end
