require 'rails/generators'

class BreezeGenerator < Rails::Generators::Base
  def install_breeze
    in_root { run(extify("ln -s vendor/plugins/breeze/public public/breeze")) }
  end
end