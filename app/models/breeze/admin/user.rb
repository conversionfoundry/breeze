module Breeze
  module Admin
    class User
      include Mongoid::Document
      extend ActiveSupport::Memoizable
    
      field :first_name
      field :last_name
      field :display_name

      validates_presence_of :first_name, :last_name
    
      devise :database_authenticatable, :recoverable, :rememberable
      
      def name
        display_name || [ first_name, last_name ].compact.join(" ")
      end
      memoize :name
      alias_method :to_s, :name
    end
  end
end