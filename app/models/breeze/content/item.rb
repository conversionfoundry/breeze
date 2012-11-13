module Breeze
  module Content
    class Item
      include Mongoid::Document
      include Mongoid::Timestamps
      include ActiveModel::Serializers::Xml
      include Mixins::Markdown
      include Mongoid::FullTextSearch

      field :_id, type: String, default: -> { Moped::BSON::ObjectId.new.to_s }
      field :template
      
      attr_protected :_id

      fulltext_search_in :fts_index, filters: { is_placeable: ->(el) { el.is_a? Breeze::Content::Mixins::Placeable } } 
      
      index({parent_id: 1, _type: 1})
      
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

      def duplicate(attrs = {}) #here we can have attrs = {placement_counts:1} as a parameter
        new_record = yield if block_given?
        new_record ||= self.dup
        new_record.tap do |r|
          r.created_at = nil
          r.touch # refresh updated_at
          r.save
        end
      end
      
      def self.search_for_text(query, options={})
        self.fulltext_search(query, is_placeable: true)
      end
      
      # def self._types
      #   @_type ||= [recurse_subclasses + Breeze::Content::Custom::Type.classes(self).map(&:name)].flatten.uniq.map(&:to_s)
      # end
      
      def self.recurse_subclasses
        [self].tap do |result|
          ObjectSpace.each_object(Class) { |klass| result << klass if klass < self }
        end
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
      
      def self.view_class
        @view_class = self.nil? ? View : [self.name, "View"].join.constantize
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
