module Breeze
  module Admin
    class DashboardsController < AdminController

   	  include AdminHelper

      def show
        @log_messages = Activity::LogMessage.order_by([[ :created_at, -1 ]]).paginate :page => 1, :per_page => 3

        @dashboard_panels = []
        @dashboard_panels = Breeze.run_hook :dashboard_panels, @dashboard_panels, current_user
        @dashboard_panels << { partial: "breeze/admin/dashboard_panels/log_messages" }
        @dashboard_panels << { partial: "breeze/admin/dashboard_panels/component_info", locals: {component_info: component_info} }
				

      end
    end
  end
end