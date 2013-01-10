module Breeze
  module Content
    module Custom
      class Type
        include Mongoid::Document
        field :name
        field :type_name
        attr_protected :_id

        validates :name, uniqueness: true, presence: true,
          format: { with: /^(\w|\d|\s|-)*$/, message: "Can contain only digits, letters, space, dashes and underscores." }
        index({ name: 1 }, { unique: true })

        validates :type_name, presence: true, uniqueness: true,
          format: { with: /^[A-Z]\w*$/, message: "must be a CamelCasedName" }
        index({ type_name: 1 }, { unique: true })

        embeds_many :custom_fields, :class_name => "Breeze::Content::Custom::Field" do
          def build(attrs = {}, type = nil)
            attrs ||= {}
            klass = attrs.delete(:_type).try(:constantize) || StringField
            super attrs, klass
          end
          
          def nested_build(attributes, options = {})
            attributes.each do |index, attrs|
              if attrs[:id].present? && document = detect { |document| document.id == attrs[:id] }
                if options && options[:allow_destroy] && attrs['_destroy']
                  @target.delete(document)
                  document.destroy
                else
                  document.write_attributes(attrs)
                  document.position = index.to_i
                end
              else
                document = build(attrs)
                document.position = index.to_i
              end
            end
            @target.sort_by(&:position).each_with_index { |document, i| document.position = i }
          end
        end
        accepts_nested_attributes_for :custom_fields, 
          :allow_destroy => true
          # :reject_if => lambda { |attrs| attrs.values.reject(&:blank?).empty? }
      
      
        before_validation :fill_in_type_name
        after_save :reset_class
        before_destroy :destroy_instances
        after_destroy :reset_class

      
        def to_class
          self.class.get(type_name)
        end
        
        delegate :default_template_name, :to => :to_class
      
        def self.get(type_name)
          @classes ||= {}
          @classes[type_name] ||= where(:type_name => type_name).first.try(:create_class)
        end
        
        def self.classes(type = nil)
          @all_classes ||= all.map(&:to_class)
          if type
            @all_classes.select { |c| c.ancestors.include?(type) }
          else
            @all_classes
          end
        end
      
      protected
        def create_class
          Class.new(Breeze::Content::Custom::Instance).tap do |klass|
            klass.send(:include, Breeze::Content::Mixins::Placeable)
            custom_fields.each do |field|
              field.define_on klass
            end
            Breeze::Content.const_set type_name, klass
            Breeze::Content.register_class "Breeze::Content::#{type_name}"
          end
        end
      
        def fill_in_type_name
          self.type_name ||= name.underscore.gsub(/\s+/, "_").camelize if name
        end
        
        def destroy_instances
          to_class.destroy_all
        end
      
        def reset_class
          self.class.reset(type_name)
        end
      
        def self.reset(type_name)
          @classes.delete type_name if @classes
          @all_classes = []
          Breeze::Content.send(:remove_const, type_name) if Breeze::Content.const_defined?(type_name)
          Breeze::Content.unregister_class "Breeze::Content::#{type_name}"
        end
      end
    end
  end
end
