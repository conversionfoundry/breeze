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

        def label
          name.demodulize.underscore.humanize
        end

        embedded_in :custom_type, 
          class_name: "Breeze::Content::CustomType",
          inverse_of: :fields

      private 

        def fill_in_name
          self.name = self.label.underscore.gsub(/\s+/, "_") if self.name.blank? && !self.label.blank?
        end

      end
    end
  end
end

