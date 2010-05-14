module Breeze
  module Content
    class View
      include Mongoid::Document
      
      embedded_in :content_item, :inverse_of => :views
      field :name
      
      attr_accessor :controller
      attr_accessor :request
      attr_accessor :content
      
      delegate :to_xml, :to_json, :to => :content
            
      def content
        @content || content_item
      end      
      
      def populate(content, controller, request)
        returning dup do |view|
          view.content, view.controller, view.request = content, controller, request
        end
      end
      
      def render!
        format = (request.format || Mime[:html]).to_sym
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
            raise Breeze::Errors::NotAcceptable, request
          end
        end
      end
      
      def template
        content.template || content.class.self_and_superclasses.detect do |klass|
          controller.template_exists? klass.default_template_name, "layouts"
        end.try(:default_template_name)
      end

      def variables_for_render
        { :content => content }
      end
    end
  end
end