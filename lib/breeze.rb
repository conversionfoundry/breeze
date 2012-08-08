#module Breeze
  #extend self
  #extend Breeze::Hooks
  #extend Breeze::Queueing

  #def version
    #"0.0.1"
  #end
  
  #def config
    #@config ||= Configuration.first || Configuration.create
  #end
  
  #def with_domain(domain, &block)
    #old_domain, @_domain = @_domain, domain
    #yield
    #@_domain = old_domain
  #end
  
  #def domain
    #@_domain
  #end
#end

#require "breeze/theming"
#require "breeze/admin/activity"

require "breeze/engine"
require "breeze/hooks"
require "breeze/queueing"
require "breeze/queueing/strategy"
require "breeze/queueing/synchronous"
require "breeze/queueing/resque"

module Breeze
  extend self
  extend Breeze::Hooks
  extend Breeze::Queueing

  def config
    @config ||= Configuration.first || Configuration.create
  end
  
  def with_domain(domain, &block)
    old_domain, @_domain = @_domain, domain
    yield
    @_domain = old_domain
  end
  
  def domain
    @_domain
  end
end

require "breeze/configuration"
require "breeze/theming"
require "breeze/admin/activity"
require "breeze/errors"
require "breeze/content"
require "breeze/admin/form_builder"

