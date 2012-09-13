module Breeze
  module Content
    module Custom
      class Field
        include Mongoid::Document
        field :identity, :type => String
        
        field :name
        field :label
        field :position, :type => Integer
        embedded_in :custom_type, :inverse_of => :fields
        
        before_validation :fill_in_name
        validates_presence_of :name
        validates_format_of :name, :with => /^[a-z]\w*$/, :message => "must consist of lower-case letters, numbers and underscores"
        
        def define_on(klass)
          klass.field name
        end
        
        def <=>(another)
          position <=> another.position
        end
        
        def editor(form)
          form.text_field name.to_sym, :label => label
        end
        
        def to_html(view, instance)
          "<div class=\"#{name}\">#{instance.send name.to_sym}</div>"
        end
        
        def self.label
          name.demodulize.underscore.humanize
        end
        
        def self.types
          @_field_types ||= subclasses.map(&:to_s).sort.map &:constantize
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
