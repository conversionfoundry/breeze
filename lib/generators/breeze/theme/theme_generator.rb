require 'rails/generators'

module Breeze
  module Generators
    class ThemeGenerator < Rails::Generators::NamedBase
      def create_theme
        in_root do
          run extify("mkdir -p ./vendor/themes/#{name}/{images,javascripts,layouts,partials,stylesheets}")
        end
      end
    end
  end
end
