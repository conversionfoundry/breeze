require 'set'

module Breeze
  module Admin
    class User
      include Mongoid::Document
      extend ActiveSupport::Memoizable
      identity :type => String
    
      field :first_name
      field :last_name
      field :display_name
      field :roles, :type => Array, :default => []
      field :menu_order, :type => Array, :default => []

      validates_presence_of :first_name, :last_name, :email
      validates_presence_of :password, :password_confirmation, :if => :new_record?
      validates_confirmation_of :password
    
      devise :database_authenticatable, :recoverable, :rememberable
      
      ## Database authenticatable
      field :email,              :type => String, :null => false
      field :encrypted_password, :type => String, :null => false

      ## Recoverable
      field :reset_password_token,   :type => String
      field :reset_password_sent_at, :type => Time

      ## Rememberable
      field :remember_created_at, :type => Time

      ## Trackable
      field :sign_in_count,      :type => Integer
      field :current_sign_in_at, :type => Time
      field :last_sign_in_at,    :type => Time
      field :current_sign_in_ip, :type => String
      field :last_sign_in_ip,    :type => String

      ## Encryptable
      # field :password_salt, :type => String

      ## Confirmable
      # field :confirmation_token,   :type => String
      # field :confirmed_at,         :type => Time
      # field :confirmation_sent_at, :type => Time
      # field :unconfirmed_email,    :type => String # Only if using reconfirmable

      ## Lockable
      # field :failed_attempts, :type => Integer # Only if lock strategy is :failed_attempts
      # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
      # field :locked_at,       :type => Time

      # Token authenticatable
      # field :authentication_token, :type => String

      ## Invitable
      # field :invitation_token, :type => String
        
      ROLES = [ :admin, :editor, :designer ]
      
      def name
        @name ||= display_name.blank? ? [ first_name, last_name ].compact.join(" ") : display_name
      end
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
        @_roles ||= ({}).tap do |hash|
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
