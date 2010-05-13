require 'rails/generators'

class BreezeGenerator < Rails::Generators::Base
  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end
  
  def install_breeze
    copy_file "devise.rb", "config/initializers/devise.rb"
    copy_file "devise.en.yml", "config/locales/devise.en.yml"
    in_root { inside("public") { run(extify("ln -s ../vendor/plugins/breeze/public breeze")) } }
  end
end