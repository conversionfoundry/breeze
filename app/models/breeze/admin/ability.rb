module Breeze
  module Admin
    class Ability
      include CanCan::Ability
      
      def initialize(user)
        can :read, :all

        case user
        when User
          can :manage,       Breeze::Content::Page
          can :manage,       Breeze::Content::Type if user.admin? || user.designer?
          can :manage,       Breeze::Theming::Theme if user.admin? || user.designer?
          can :create,       Breeze::Admin::User   do |subject| ; user.admin?                    ; end
          can :update,       Breeze::Admin::User   do |subject| ; user.admin? || user == subject ; end
          can :destroy,      Breeze::Admin::User   do |subject| ; user.admin? && user != subject ; end
          can :assign_roles, Breeze::Admin::User   do |subject| ; user.admin?                    ; end
        end
        
        # Check engines for additional abilities
        # Breeze.run_hook :define_abilities, user, self
        Breeze.run_hook :define_abilities, self, user, self
      end

      def self.role_description(role)
        case role
        when :admin
          "can do all a designer can do, plus manage other users"
        when :designer
          "can do all an editor can do, plus work on themes and custom types"
        when :editor
          "can work on content, pages and assets"
        else
          ""
        end
      end
    end
  end
end
