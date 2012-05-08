module Breeze
  module Content
    class View
      include Mongoid::Document
      identity :type => String

      extend ActiveSupport::Memoizable
      
      embedded_in :content_item, :inverse_of => :views
      field :name
      
      attr_accessor :controller
      attr_accessor :request
      attr_accessor :content
      
      delegate :to_xml, :to_json, :to => :content

      def to_s; name; end
            
      def content
        @content || content_item
      end      
      
      def populate(content, controller, request)
        dup.tap do |view|
          view.content, view.controller, view.request = content, controller, request
        end
      end
      
      def render!
        format = (request.format || Mime[:html]).to_sym
        format = :html if format.to_s == "*/*" # IE!
        renderer = :"render_as_#{format.to_sym}"

        if respond_to?(renderer)
          send renderer
        else
          converter = :"to_#{format}"
          if respond_to? converter
            controller.send :render, format => send(converter)
          elsif content.respond_to? converter
            controller.send :render, format => content.send(converter)
          else
            Rails.logger.info "Could not render as #{format}".red
            raise Breeze::Errors::NotAcceptable, request
          end
        end
      end
      
      def template
        if content.template.blank?
          content.class.self_and_superclasses.detect do |klass|
            controller.template_exists? klass.default_template_name, "layouts"
          end.try(:default_template_name)
        else
          content.template
        end
      end

      def variables_for_render
        @variables_for_render ||= content.variables_for_render.merge(:view => self)
      end
    end
  end
end
