module Breeze
  module Content
    module Custom
      class Field
        include Mongoid::Document

        field :name, type: String
        field :label, type: String
        field :field_type, type: String

        validates :name, 
          presence: true, 
          format: { with: /^[\w\d-]*$/, 
            message: "must consist of lower-case letters, numbers, dashes and underscores." }

        before_validation :fill_in_name

        embedded_in :custom_type, 
          class_name: "Breeze::Content::CustomType",
          inverse_of: :fields

        def label
          name.demodulize.underscore.humanize
        end

      private 

        def fill_in_name
          if name.blank? && label.present?
            self.name = self.label.underscore.gsub(/\s+/, "_")
          end
        end
      end
    end
  end
end

