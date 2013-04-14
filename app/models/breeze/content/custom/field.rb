module Breeze
  module Content
    module Custom
      class Field
        include Mongoid::Document

        TYPES = [ :text, :markdown, :url ].freeze

        field :label, type: String
        field :name, type: String
        field :type, type: Symbol, default: :text # see TYPES
        field :position, type: Integer, default: 0

        validates :label,
          presence: true

        validates :name, 
          format: { with: /^[\w\d-]*$/, 
            message: "must consist of lower-case letters, numbers, " +
            "dashes and underscores." }

        before_validation :set_defaults

        # validates :position,
        #   uniqueness: true # As embedded object it will be unique in the scope
        # # of its container
        # This will actually be a transversal concern Position

        embedded_in :content_type, 
          class_name: "Breeze::Content::Type",
          inverse_of: :content_fields

        attr_accessible :name, :label, :field_type, :position

        # Accessor of the constant array
        def self.types
          TYPES
        end

      private 

        def set_defaults
          fill_in_name
          # find_a_position
        end
      
        def fill_in_name
          self.name ||= label.underscore.gsub(/\s+/, "_") if label.present?
        end

      end
    end
  end
end

