module Breeze
  module Content
    module Custom
      class Field
        include Mongoid::Document
        
        field :name
        field :label
        field :position, :type => Integer
        embedded_in :custom_type, :inverse_of => :fields
        
        before_validate :fill_in_name
        validates_presence_of :name
        validates_format_of :name, :with => /^[a-z]\w*$/, :message => "must consist of lower-case letters, numbers and underscores"
        
        def define_on(klass)
          klass.field name
        end
        
        def <=>(another)
          _index.to_i <=> another._index.to_i
        end
        
        def self.label
          self.class.name.demodulize.humanize
        end
        
        def self.types
          @_field_types ||= subclasses.sort.map &:constantize
        end
        
      protected
        def fill_in_name
          self.name = self.label.underscore.gsub(/\s+/, "_") if self.name.blank? && !self.label.blank?
        end
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "*_field.rb")].each { |f| require f }