module Breeze
  module Admin
    class Ability
      include CanCan::Ability
      
      def initialize(user)
        can :read, :all

        case user
        when User
          can :manage,       Breeze::Content::Item
          can :update,       Breeze::Admin::User   do |subject| ; user.admin? || user == subject ; end
          can :destroy,      Breeze::Admin::User   do |subject| ; user.admin? && user != subject ; end
          can :assign_roles, Breeze::Admin::User   do |subject| ; user.admin?                    ; end
        end
      end
    end
  end
end