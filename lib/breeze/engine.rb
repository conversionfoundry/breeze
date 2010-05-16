require "rails"

module Breeze
  class Engine < Rails::Engine
    engine_name :breeze
    
    rake_tasks do
      load "breeze/tasks/rspec.rake"
    end
  end
end