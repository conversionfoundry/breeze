module Breeze
  module Content
    class Item
      include Mongoid::Document
      include Mongoid::Timestamps
      include ActiveModel::Serializers::Xml
      include Mixins::Markdown

      field :template
      
      attr_protected :_id

      index({parent_id: 1, _type: 1})
      
      alias_method :type, :_type
      
      def variables_for_render
        { :content => self }
      end
      
      
      

      # Return a string suitable for use as a class name in HTML markup
      def self.html_class
        @html_class ||= 'breeze-' + name.demodulize.underscore
      end
      
      def html_class
        self.class.html_class
      end

      def self.base_class
        if self.to_s == "Breeze::Content::Item" || superclass.to_s == "Breeze::Content::Item" || superclass == Object
          self
        else
          superclass.base_class
        end
      end
      def base_class; self.class.base_class; end
      
      def self.self_and_superclasses
        [self].tap do |list|
          list.concat superclass.self_and_superclasses if superclass.respond_to?(:self_and_superclasses)
        end
      end
      
      def self.default_template_name
        name.demodulize.underscore
      end
      
      def self.label
        name.demodulize.underscore.humanize
      end
      
      def self.factory(*args)
        params = args.extract_options! || {}
        type = params.delete(:_type) || args.first || self.name
        klass = begin
          klass = case type
          when Class then type
          else type.to_s.constantize
          end
        rescue
          self
        end
        klass.new params
      end
      
    private
      
      def fts_index
        potential_fields = [:fts, :name, :content, :extra, :title].freeze
        "".tap do |index|
          potential_fields.each do |field_sym|
            index << " #{send(field_sym)}" if respond_to?(field_sym) && send(field_sym)
          end
        end
      end
    end
  end
end
