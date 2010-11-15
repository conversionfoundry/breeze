module Breeze
  module Admin
    class UsersController < AdminController
      before_filter :load_user, :only => [ :show, :edit, :update, :preferences, :destroy ]
      load_and_authorize_resource :class => User, :except => :preferences
      
      def index
        @users = User.all.sort_by &:to_s
      end
      
      def new
        
      end
      
      def create
        
      end
      
      def edit
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