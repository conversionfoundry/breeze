module Breeze
  module Content
    module Custom
      class Type
        include Mongoid::Document
      
        field :name
        field :type_name
        embeds_many :custom_fields, :class_name => "Breeze::Content::Custom::Field" do
          def build(attrs = {}, type = nil)
            attrs ||= {}
            klass = attrs.delete(:_type).try(:constantize) || StringField
            super attrs, klass
          end
        end
        accepts_nested_attributes_for :custom_fields, 
          :reject_if => lambda { |attrs| attrs.values.reject(&:blank?).empty? },
          :allow_destroy => true
      
        index :type_name, :unique => true
      
        before_validate :fill_in_type_name
        after_save :reset_class

        validates_presence_of :name
        validates_uniqueness_of :name
        validates_format_of :type_name, :with => /^[A-Z]\w*$/, :message => "must be a CamelCasedName"
        validates_uniqueness_of :type_name
      
        def to_class
          returning Class.new(Breeze::Content::Custom::Instance) do |klass|
            custom_fields.each do |field|
              field.define_on klass
            end
            Breeze::Content.const_set type_name, klass
          end
        end
      
        def self.get(type_name)
          @classes ||= {}
          @classes[type_name] ||= where(:type_name => type_name).first.try(:to_class)
        end
      
      protected
        def fill_in_type_name
          self.type_name = name.underscore.gsub(/\s+/, "_").camelize if type_name.blank? && !name.blank?
        end
      
        def reset_class
          self.class.reset(type_name)
        end
      
        def self.reset(type_name)
          @classes.delete type_name
          Breeze::Content.send :remove_const, type_name if Breeze::Content.const_defined?(type_name)
        end
      end
    end
  end
end