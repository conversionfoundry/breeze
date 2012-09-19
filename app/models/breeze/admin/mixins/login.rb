# Fields for Devise 2.0
# Used for Breeze::Admin::User and Breeze::Account::Customer
module Breeze
  module Admin
    module Mixins
      module Login
        extend ActiveSupport::Concern

        included do
          devise :database_authenticatable, :recoverable, :rememberable

          # Database authenticatable
          field :email, :type => String
          field :encrypted_password, :type => String

          ## Recoverable
          field :reset_password_token,   :type => String
          field :reset_password_sent_at, :type => Time

          ## Rememberable
          field :remember_created_at, :type => Time
          
          index({email: 1}, {unique: true})
          validates :email, uniqueness: true, presence: true

          ## Trackable
          # field :sign_in_count,      :type => Integer
          # field :current_sign_in_at, :type => Time
          # field :last_sign_in_at,    :type => Time
          # field :current_sign_in_ip, :type => String
          # field :last_sign_in_ip,    :type => String

          # Encryptable
          # base.field :password_salt, :type => String

          # Confirmable
          # base.field :confirmation_token,   :type => String
          # base.field :confirmed_at,         :type => Time
          # base.field :confirmation_sent_at, :type => Time
          # base.field :unconfirmed_email,    :type => String # Only if using reconfirmable

          # Lockable
          # base.field :failed_attempts, :type => Integer # Only if lock strategy is :failed_attempts
          # base.field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
          # base.field :locked_at,       :type => Time

          # Token authenticatable
          # base.field :authentication_token, :type => String

          # Invitable
          # base.field :invitation_token, :type => String
        end

        module ClassMethods
        end
      end
    end
  end
end
