require 'set'
module Breeze
  module Admin
    ##
    # This class represents any user interacting on breeze. It embeds its logic in the model, connectors for roles and email triggering.
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

      has_many_related :log_messages, :class_name => "Breeze::Admin::Activity::LogMessage"
    
      after_create :schedule_new_user_email

      include Mixins::Login
      
      ##
      # Array of current available roles
      ROLES = [ :editor, :designer, :admin ]
      
      ##
      # :method: can?
      # Check user permission (in a Cancan fashion)

      ##
      # :method: cannot?
      # Negation of #can? method 
      delegate :can?, :cannot?, :to => :ability

      ## 
      # Returns a formated user name, this method is aliased by #to_s
      def name
        @name ||= display_name.blank? ? [ first_name, last_name ].compact.map(&:humanize).shelljoin : display_name
      end
      alias_method :to_s, :name
      
      ##
      # Returns true if the user own the +sym+ role
      def role?(sym)
        roles.include? sym.to_sym
      end
     
      ##
      # Sets roles to the user given an array of symbols
      #
      # Current roles available are get_constant(ROLES)
      def roles=(values)
        write_attribute :roles, Array(values).flatten.reject(&:blank?).uniq.map(&:to_sym)
      end
      


      ## 
      # Returns the hash of current available roles 
      #
      # Example
      #   {
      #     :admin => "Administrator",
      #     :designer => "Designer",
      #     :editor => "Editor"
      #   }
      def self.roles
        @_roles ||= ({}).tap do |hash|
          ROLES.each do |role|
            hash[role] = I18n::t role, :scope => [ :breeze, :users, :roles ], :default => role.to_s.humanize
          end
        end
      end
      
      ##
      # Yield the block given switching the context user @_user temporarily
      def self.with_user(user)
        old_user, @_user = @_user, user
        yield
        @_user = old_user
      end
      
      ##
      # Returns the context user
      def self.current
        @_user
      end
    
    protected
      ##
      # Add the new user email into the queue of background tasks 
      def schedule_new_user_email
        Breeze.queue self, :deliver_new_user_email!
      end

    private
      def method_missing(sym, *args)
        if sym.to_s =~ /^(\w+)\?$/ && ROLES.include?($1.to_sym)
          roles.include? $1.to_sym
        else
          super
        end
      end
      
      ##
      # Returns an instance of Admin::Ability for self 
      def ability
        @ability ||= Ability.new(self)
      end

      ## 
      # Delivers new user email
      def deliver_new_user_email!
        Breeze::Admin::UserAccountMailer.new_user_account_notification(self).deliver
      end
    end
  end
end
