require 'rails/generators'

module Breeze
  module Generators
    class ThemeGenerator < Rails::Generators::NamedBase
      def create_theme
        in_root do
          FileUtils.cp_r Breeze::Engine.root.to_s + "/vendor/themes/template", Rails.root.to_s + "/vendor/themes/template"
          FileUtils.mv Rails.root.to_s + "/vendor/themes/template", Rails.root.to_s + "/vendor/themes/#{name}"
        end
      end
    end
  end
end
