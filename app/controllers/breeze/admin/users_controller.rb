module Breeze
  module Admin
    class UsersController < AdminController
      unloadable
      
      def index
        @users = User.all.sort_by &:to_s
      end
      
      def edit
        @user = User.find params[:id]
      end
      
      def update
        @user = User.find params[:id]
        @user.update_attributes params[:user]
      end
    end
  end
end