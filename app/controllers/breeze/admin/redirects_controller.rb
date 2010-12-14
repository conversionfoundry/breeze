module Breeze
  module Admin
    class RedirectsController < AdminController
      def create
        @redirect = Breeze::Content::Redirect.new params[:redirect]
        @redirect.save
        Rails.logger.info @redirect.errors.inspect.red
      end
      
      def destroy
        @redirect = Breeze::Content::Redirect.find params[:id]
        @redirect.destroy
      end
      
    end
  end
end