module Breeze
  module Content
    class Item
      include Mongoid::Document
      include Mongoid::Timestamps
      identity :type => String

      include ActiveModel::Serializers::Xml
      include Mixins::Markdown
      
      field :template
      
      embeds_many :views, :class_name => "Breeze::Content::View" do
        def default
          @target.first || @base.view_class.new(:name => "default")
        end
        
        def by_name(name)
          detect { |v| v.name == name } || default
        end
      end
      
      def view_for(controller, request)
        views.default
      end
      
      def type; _type; end
      
      def render(controller, request)
        request.format ||= Mime[:html]
        controller.view = view_for(controller, request).populate(self, controller, request)
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

      def duplicate(attrs = {})
        self.class.new.tap do |duplicate|
          duplicate.attributes = @attributes.except(*%w(_id id versions placements)).dup
          duplicate.attributes = attrs
          duplicate.save
        end
      end
      
      def contains_text(*strings)
        options = strings.extract_options!
        if options[:all]
          strings.each do |string|
            return false unless @attributes.any? { |_, value| String === value && value.index(string) }
          end
          true
        else
          strings.each do |string|
            return true if @attributes.any? { |_, value| String === value && value.index(string) }
          end
          false
        end
      end
      
      def self._types
        @_type ||= [recurse_subclasses + Breeze::Content::Custom::Type.classes(self).map(&:name)].flatten.uniq.map(&:to_s)
      end
      
      def self.recurse_subclasses
        [self].tap do |result|
          ObjectSpace.each_object(Class) { |klass| result << klass if klass < self }
        end
      end

      def self.html_class
        @html_class ||= name.demodulize.parameterize
      end
      def html_class; self.class.html_class; end

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
        type = params.delete(:_type) || args.first || self.name
        klass = begin
          klass = case type
          when Class then type
          else type.to_s.constantize
          end
        rescue
          self
        end
        # raise ArgumentError, "#{klass.name} is not a valid content class" unless klass.ancestors.include?(Breeze::Content::Item)
        klass.new params
      end
      
      def self.search(&block)
        [].tap do |results|
          collection.find do |cursor|
            cursor.each do |document|
              score = block.call document
              results << [ document, score == true ? 1.0 : score ] unless score == false
            end
          end
        end.sort_by(&:last).map(&:first).reverse
      end
      
      def self.search_for_text(query, options = {})
        query = query.split(/\s+/).reject(&:blank?).map { |s| Regexp.new s.strip, Regexp::IGNORECASE }
        query << options.reverse_merge(:all => true)
        search do |item|
          (!options[:class] || item.is_a?(options[:class])) && item.contains_text(*query)
        end
      end
    end
  end
end
