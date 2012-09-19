# Here is the loading of files in order
require "breeze/engine"
require "breeze/queueing/strategy"
require "breeze/admin/activity"
require "breeze/admin/form_builder"
require "breeze/configuration"
require "breeze/errors"
require "breeze/hooks"
require "breeze/queueing/strategy"
require "breeze/queueing/resque"
require "breeze/queueing/synchronous"
require "breeze/queueing"
require "breeze/theming"
# Next we load the model
# The following paragraph contains the loading of our model, looks quite messy but it resolve dependencies
# note the require function does not require twice file, but identity if it is already in the LOAD_PATH
# p $: #Dir[File.expand_path("./../app/models/breeze/**/*.rb", File.dirname(__FILE__))]
Dir[File.expand_path("./../app/uploaders/**/*.rb", File.dirname(__FILE__))].each { |f| require f }
Dir[File.expand_path("./../app/models/breeze/content/mixins/*.rb", File.dirname(__FILE__))].each { |f| require f }
require File.expand_path("./../app/models/breeze/content/item.rb", File.dirname(__FILE__))
require File.expand_path("./../app/models/breeze/content/view.rb", File.dirname(__FILE__))
Dir[File.expand_path("./../app/models/breeze/**/*.rb", File.dirname(__FILE__))].each { |f| require f }
require "breeze/content"

module Breeze
  extend self
  extend Breeze::Hooks
  extend Breeze::Queueing

  def config
    @config ||= Configuration.first || Configuration.create
  end
  
  def with_domain domain
    old_domain, @_domain = @_domain, domain
    yield
    @_domain = old_domain
  end
  
  def domain
    @_domain
  end
end


