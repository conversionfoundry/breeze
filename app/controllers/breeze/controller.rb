require 'will_paginate/view_helpers/action_view'

module Breeze
  class Controller < ApplicationController
    helper ContentsHelper
    helper WillPaginate::ViewHelpers::ActionView

    around_filter :set_time_zone
    around_filter :set_domain_from_request
    
    rescue_from Breeze::Errors::RequestError do |error|
      respond_to do |format|
        @error = error
        format.html { render :file => "breeze/errors/#{error.to_sym}", :layout => "error", :status => error.status_code }
        format.xml  { render :xml => "", :status => error.status_code }
        format.any  { render :nothing => true, :status => error.status_code }
      end
    end
    
    rescue_from CanCan::AccessDenied do
      respond_to do |format|
        format.html do
          if request.xhr?
            render :file => "breeze/errors/access_denied", :layout => false
          else
            flash[:error] = "Sorry, looks like you don't have permission to do that."
            redirect_to admin_root_path
          end
        end
        format.js { head :access_denied }
      end
    end
    
  protected
    def lookup_context
      @lookup_context ||= returning(ActionView::LookupContext.new(self.class._view_paths, details_for_lookup)) do |context|
        context.view_paths.insert 1, *Breeze::Theming::Theme.view_paths
      end
    end

    def view_context
      returning super do |context|
        class << context
          def method_missing(sym, *args, &block)
            variables_for_render[sym] || super
          end
          
          def variables_for_render
            assigns['variables_for_render'] ||= {}
          end
        end
      end
    end

    def set_domain_from_request(&block)
      Breeze.with_domain "#{request.protocol}#{request.host_with_port}", &block
    end
    
    def set_time_zone
      old_time_zone, Time.zone = Time.zone, Breeze.config.time_zone
      yield
      Time.zone = old_time_zone
    end
  end
end