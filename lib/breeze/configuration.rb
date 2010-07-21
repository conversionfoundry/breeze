module Breeze
  class Configuration
    include Mongoid::Document
    
    field :time_zone, :default => lambda { Rails.application.config.time_zone }
    
    def time_zone
      update_attributes :time_zone => Rails.application.config.time_zone if read_attribute(:time_zone).nil?
      read_attribute :time_zone
    end
  end
  
  def self.configure(&block)
    Rails::Application.configure do
      config.to_prepare &block
    end
  end
end