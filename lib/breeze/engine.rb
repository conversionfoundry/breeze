require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "active_support/railtie"
require "sprockets/railtie"
require "carrierwave"
require "mongoid"
require "carrierwave/mongoid"
require "pry-rails"
require "cancan"
require "rmagick"

require File.expand_path("../../../config/initializers/devise.rb", __FILE__)

module Breeze
  class Engine < ::Rails::Engine
    isolate_namespace Breeze

    initializer "breeze.assets.precompile" do |app|
      app.config.assets.prefix = "/cached"
      app.config.assets.precompile += [ "breeze/*", "breeze/icons/*", "breeze/log/*", "breeze/marquess/*" ]
    end

    #For the generators. I add a config.generators block to my engine.rb file like so.
    #With that, I'm able to get rspec tests when running a generator like the model generator.
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
  end
end

