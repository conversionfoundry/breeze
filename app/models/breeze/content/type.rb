module Breeze
  module Content
    class Type 
      include Mongoid::Document

      field :name, type: String
      field :type_name, type: String

      attr_accessible :name, :type_name, :fields

      validates :name, 
        uniqueness: true, 
        presence: true,
        format: { with: /^[\w\d\s-]*$/, 
          message: "Can contain only digits, letters, space," +
          " dashes and underscores." }
      index({ name: 1 }, { unique: true }) # Uniqueness index

      validates :type_name, 
        presence: true, 
        uniqueness: true,
        format: { with: /^[A-Z]\w*$/, 
          message: "must be a CamelCasedName" }
      index({ type_name: 1 }, { unique: true }) # Uniqueness index

      embeds_many :fields, 
        class_name: "Breeze::Content::Custom::Field",
        inverse_of: :type

      accepts_nested_attributes_for :fields, 
        :allow_destroy => true

      before_validation :fill_in_type_name

    private

      def fill_in_type_name
        self.type_name ||= name.underscore.gsub(/\s+/, "_").camelize if name
      end

    end
  end
end
