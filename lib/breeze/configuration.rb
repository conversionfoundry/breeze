module Breeze
  class Configuration
    include Mongoid::Document
  end
  
  def self.configure(&block)
    Rails::Application.configure do
      config.to_prepare &block
    end
  end
end