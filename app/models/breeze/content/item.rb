module Breeze
  module Content
    class Item
      include Mongoid::Document
      include ActiveModel::Serializers::Xml
      
      embeds_many :views, :class_name => "Breeze::Content::View" do
        def default
          @target.first || @parent.view_class.new(:name => "default")
        end
      end
      
      def view_for(request)
        views.default
      end
      
      def type; _type; end
      
      def perform(controller, request)
        request.format ||= Mime[:html]
        view = view_for(request).populate(self, controller, request)
        view.render!
        controller.performed?
      end
      
      def to_xml(options = {})
        super options.reverse_merge(:except => [ :_id, :_type ], :methods => [ :id, :type ], :root => self.base_class.name.demodulize.underscore)
      end

      def self.base_class
        if self == Item || superclass == Item || superclass == Object
          self
        else
          superclass.base_class
        end
      end
      def base_class; self.class.base_class; end
      
      def self.view_class
        @view_class ||= begin
          (self.name + "View").constantize
        rescue
          View
        end
      end
      def view_class; self.class.view_class; end      
    end
  end
end