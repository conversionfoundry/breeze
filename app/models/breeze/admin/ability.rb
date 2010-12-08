module Breeze
  module Admin
    class Ability
      include CanCan::Ability
      
      def initialize(user)
        can :read, :all

        case user
        when User
          can :manage,       Breeze::Content::Item
          can :manage,       Breeze::Content::Custom::Type if user.admin? || user.designer?
          can :manage,       Breeze::Theming::Theme if user.admin? || user.designer?
          can :create,       Breeze::Admin::User   do |subject| ; user.admin?                    ; end
          can :update,       Breeze::Admin::User   do |subject| ; user.admin? || user == subject ; end
          can :destroy,      Breeze::Admin::User   do |subject| ; user.admin? && user != subject ; end
          can :assign_roles, Breeze::Admin::User   do |subject| ; user.admin?                    ; end
        end
        
        Breeze.run_hook :define_abilities, user, self
      end
    end
  end
end