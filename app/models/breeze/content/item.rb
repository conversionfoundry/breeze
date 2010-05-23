module Breeze
  module Content
    class Item
      include Mongoid::Document
      include ActiveModel::Serializers::Xml
      include Mixins::Markdown
      
      field :template
      
      embeds_many :views, :class_name => "Breeze::Content::View" do
        def default
          @target.first || @parent.view_class.new(:name => "default")
        end
        
        def by_name(name)
          name.nil? ? default : detect { |v| v.name == name }
        end
      end
      
      def view_for(request)
        views.default
      end
      
      def type; _type; end
      
      def render(controller, request)
        request.format ||= Mime[:html]
        controller.view = view_for(request).populate(self, controller, request)
        controller.view.render!
        controller.performed?
      end
      
      def variables_for_render
        { :content => self }
      end
      
      def to_xml(options = {})
        super options.reverse_merge(:except => [ :_id, :_type ], :methods => [ :id, :type ], :root => self.base_class.name.demodulize.underscore)
      end
      
      def to_erb(view)
        
      end

      def self.html_class
        @html_class ||= name.demodulize.parameterize
      end
      def html_class; self.class.html_class; end

      def self.base_class
        if self == Item || superclass == Item || superclass == Object
          self
        else
          superclass.base_class
        end
      end
      def base_class; self.class.base_class; end
      
      def self.self_and_superclasses
        returning [self] do |list|
          list.concat superclass.self_and_superclasses if superclass.respond_to?(:self_and_superclasses)
        end
      end
      
      def self.default_template_name
        name.demodulize.underscore
      end
      
      def self.view_class
        @view_class ||= begin
          (self.name + "View").constantize
        rescue
          View
        end
      end
      def view_class; self.class.view_class; end
      
      def self.label
        name.demodulize.underscore.humanize
      end
      
      def self.factory(*args)
        params = args.extract_options! || {}
        type = args.first || params.delete(:_type) || self.name
        klass = begin
          klass = case type
          when Class then type
          else type.to_s.constantize
          end
        rescue
          self
        end
        raise ArgumentError, "#{klass.name} is not a valid content class" unless klass.ancestors.include?(Breeze::Content::Item)
        klass.new params
      end
    end
  end
end