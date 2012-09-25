begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
rescue MissingSourceFile 
  module Rspec
    module Core
      class RakeTask
        def initialize(name)
          task name do
            # if rspec-rails is a configured gem, this will output helpful material and exit ...
            require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

            # ... otherwise, do this:
            raise <<-MSG

#{"*" * 80}
*  You are trying to run an rspec rake task defined in
*  #{__FILE__},
*  but rspec can not be found in vendor/gems, vendor/plugins or system gems.
#{"*" * 80}
MSG
          end
        end
      end
    end
  end
end

namespace :breeze do
  task :default => :spec

  desc "Run Breeze specs"
  Rspec::Core::RakeTask.new :spec do |t|
    t.pattern = File.expand_path("../../spec/**/*_spec.rb", File.dirname(__FILE__))
  end
end
