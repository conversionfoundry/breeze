# We dont use the following as  loading order matters
# Dir[File.expand_path("./breeze/**/*.rb", File.dirname(__FILE__))].each do |f|
#   require f
# end
#
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
Dir[File.expand_path("./../app/models/breeze/**/*.rb", File.dirname(__FILE__))].each do |f|
  require f
end
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


