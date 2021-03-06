require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "active_support/railtie"
require "sprockets/railtie"
require "carrierwave"
require "mongoid"
require "carrierwave/mongoid"
require "cancan"
require "RMagick"
require "jquery-rails"
require "rdiscount"
require "execjs"
require "mongoid_fulltext"
require "haml"
require "coffee-script"
require "jquery-fileupload-rails"
require "twitter-bootstrap-rails"
require "font-awesome-rails"
require "masonry-rails"
require "codemirror-rails"

require File.expand_path("../../../config/initializers/devise.rb", __FILE__)

module Breeze
  class Engine < Rails::Engine
    isolate_namespace Breeze

    # The term "assets" is used by Breeze, so we store precompiled Rails assets in public/cached
    initializer "breeze.assets.precompile" do |app|
      if Rails.env.development?
        # Sometimes we want to run a development instance on the same server as a production instance
        # We don't want to use precompiled production assets in development, so we point to a different directory
        # Typically, /cached_dev will be non-existent, so we don't get any precompiled assets in development
        app.config.assets.prefix = "/cached_dev"
      else
        app.config.assets.prefix = "/cached"
      end
    end

    # config.autoload_paths += ["app/models/breeze/", "app/models/breeze/admin", "app/models/breeze/admin/activity", "/app/models/breeze/admin/mixins",
    #   "app/models/breeze/content/custom", "app/models/breeze/content/mixins", "app/models/breeze/theming"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    #For the generators. I add a config.generators block to my engine.rb file like so.
    #With that, I'm able to get rspec tests when running a generator like the model generator.
    config.generators do |g|
      g.test_framework :rspec, fixture: true, view_specs: false
      g.fixture_replacement :fabrication
    end

    # Load devise layouts for the engine
    config.to_prepare do
      Devise::SessionsController.layout "sessions"
      Devise::PasswordsController.layout false
    end
  end
end

