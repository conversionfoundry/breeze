module Breeze
  module Content
    module Custom
      class Field
        include Mongoid::Document

        field :label, type: String
        field :name, type: String
        field :field_type, type: String

        validates :label,
          presence: true

        validates :name, 
          format: { with: /^[\w\d-]*$/, 
            message: "must consist of lower-case letters, numbers, " +
            "dashes and underscores." }

        before_validation :fill_in_name

        embedded_in :content_type, 
          class_name: "Breeze::Content::Type",
          inverse_of: :fields

      private 
      
        def fill_in_name
          self.name ||= label.underscore.gsub(/\s+/, "_") if label.present?
        end

      end
    end
  end
end

