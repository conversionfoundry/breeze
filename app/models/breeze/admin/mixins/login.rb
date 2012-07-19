# Fields for Devise 2.0
# Used for Breeze::Admin::User and Breeze::Account::Customer

module Breeze
  module Admin
    module Mixins
      module Login

        def self.included(base)
          base.devise :database_authenticatable, :recoverable, :rememberable
          # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable #, :validatable
      
          ## Database authenticatable
          base.field :email,              :type => String, :null => false
          base.field :encrypted_password, :type => String, :null => false

          ## Recoverable
          base.field :reset_password_token,   :type => String
          base.field :reset_password_sent_at, :type => Time

          ## Rememberable
          base.field :remember_created_at, :type => Time

          ## Trackable
          base.field :sign_in_count,      :type => Integer
          base.field :current_sign_in_at, :type => Time
          base.field :last_sign_in_at,    :type => Time
          base.field :current_sign_in_ip, :type => String
          base.field :last_sign_in_ip,    :type => String

          ## Encryptable
          # base.field :password_salt, :type => String

          ## Confirmable
          # base.field :confirmation_token,   :type => String
          # base.field :confirmed_at,         :type => Time
          # base.field :confirmation_sent_at, :type => Time
          # base.field :unconfirmed_email,    :type => String # Only if using reconfirmable

          ## Lockable
          # base.field :failed_attempts, :type => Integer # Only if lock strategy is :failed_attempts
          # base.field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
          # base.field :locked_at,       :type => Time

          # Token authenticatable
          # base.field :authentication_token, :type => String

          ## Invitable
          # base.field :invitation_token, :type => String






        end
        
      end
    end
  end
end