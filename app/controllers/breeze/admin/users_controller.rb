module Breeze
  module Admin
    class UsersController < AdminController
      before_filter :load_user, :only => [ :show, :edit, :update, :preferences, :destroy ]
      load_and_authorize_resource :class => User, :except => :preferences
      
      def index
        @users = User.all.sort_by &:to_s
        @admins = @users.select{|user| user.roles.include? :admin}
        @designers = @users.select{|user| user.roles.include? :designer and not @admins.include? user}
        @editors = @users.select{|user| not ( @admins.include? user or @designers.include? user) }
      end
      
      def new
        @user = User.new
      end
      
      def create
        @user = User.new params[:user]
        @user.save
      end
      
      def edit
      end

      def destroy
        @user.destroy
      end
      
      def update
        params[:user] ||= {}
        if can? :assign_roles, @user
          params[:user][:roles] ||= []
          params[:user][:roles] << :admin if @user.admin?
        else
          params[:user].delete :roles
        end
        @user.update_attributes params[:user]
      end
      
      def preferences
        authorize! :update, @user
        @user.update_attributes params[:user]
        render :nothing => true
      end
      
    protected
      def load_user
        @user ||= User.find params[:id]
      end
    end
  end
end