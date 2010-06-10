require 'set'

module Breeze
  module Admin
    class User
      include Mongoid::Document
      extend ActiveSupport::Memoizable
    
      field :first_name
      field :last_name
      field :display_name
      field :roles, :type => Array, :default => []
      field :menu_order, :type => Array, :default => []

      validates_presence_of :first_name, :last_name
    
      devise :database_authenticatable, :recoverable, :rememberable
      
      ROLES = [ :admin, :editor, :designer ]
      
      def name
        display_name.blank? ? [ first_name, last_name ].compact.join(" ") : display_name
      end
      memoize :name
      alias_method :to_s, :name
      
      def role?(sym)
        roles.include? sym.to_sym
      end
      
      def roles=(values)
        write_attribute :roles, Array(values).flatten.reject(&:blank?).uniq.map(&:to_sym)
      end
      
      def ability
        @ability ||= Ability.new(self)
      end
      delegate :can?, :cannot?, :to => :ability

      def method_missing(sym, *args)
        if sym.to_s =~ /^(\w+)\?$/ && ROLES.include?($1.to_sym)
          roles.include? $1.to_sym
        else
          super
        end
      end
      
      def self.roles
        @_roles ||= returning({}) do |hash|
          ROLES.each do |role|
            hash[role] = I18n::t role, :scope => [ :breeze, :users, :roles ], :default => role.to_s.humanize
          end
        end
      end
      
      def self.with_user(user)
        old_user, @_user = @_user, user
        yield
        @_user = old_user
      end
      
      def self.current
        @_user
      end
    end
  end
end