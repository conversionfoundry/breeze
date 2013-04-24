module Breeze
  module Content
    module Custom
      class Field
        include Mongoid::Document

        # Here is a useful subset of the helpers provided into FormHelper
        # http://apidock.com/rails/ActionView/Helpers/FormHelper
        # We might monkey patch FormHelper into intializers to add a
        # markdown_area method 
        TYPES = [ :text_field,
          :text_area, 
          :url_field, 
          :email_field,
          :search_field,
          :range_field,
          :file_field,
          :check_box,
          :phone_field,
          :number_field,
          :password_field,
          :hidden_field
        ].freeze

        field :label, type: String
        field :name, type: String
        field :type, type: Symbol, default: :text_field # see TYPES
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

