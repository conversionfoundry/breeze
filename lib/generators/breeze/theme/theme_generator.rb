require 'rails/generators'

module Breeze
  module Generators
    class ThemeGenerator < Rails::Generators::NamedBase
      def create_theme
        in_root do
          run extify("mkdir -p ./vendor/themes/#{name}/images")
          run extify("mkdir -p ./vendor/themes/#{name}/javascripts")
          run extify("mkdir -p ./vendor/themes/#{name}/layouts")
          run extify("mkdir -p ./vendor/themes/#{name}/partials")
          run extify("mkdir -p ./vendor/themes/#{name}/stylesheets")
        end
      end
    end
  end
end
