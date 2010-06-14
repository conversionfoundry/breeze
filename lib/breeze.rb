module Breeze
  def self.version
    "0.0.1"
  end
  
  def self.config
    @config ||= Configuration.first || Configuration.create
  end
end

require "breeze/theming"
require "breeze/admin/activity"
