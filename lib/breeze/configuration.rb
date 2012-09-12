module Breeze
  class Configuration
    include Mongoid::Document
    # identity :type => String
    
    field :time_zone, :default => lambda { Rails.application.config.time_zone }
    field :notification_from_email, :default => "system@example.com"
    
    def time_zone
      update_attributes :time_zone => Rails.application.config.time_zone if read_attribute(:time_zone).nil?
      read_attribute :time_zone
    end

    def notification_from_email
      update_attributes :notification_from_email => Rails.application.config.notification_from_email if read_attribute(:notification_from_email).nil?
      read_attribute :notification_from_email
    end

  end
  
  def self.configure #(&block)
    Rails::Application.configure do
      config.to_prepare yield 
    end
  end
end
