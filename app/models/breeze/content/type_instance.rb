module Breeze
  module Content
    class TypeInstance
      include Mongoid::Document
      # In this model we use dynamic fields to store the set of values Read
      # this http://mongoid.org/en/mongoid/docs/documents.html#dynamic_fields
      # The related object will have more attributes than described. However no
      # setter/getter is generated

      field :region, type: String 

      belongs_to :content_type, 
        class_name: "Breeze::Content::Type"
      embedded_in :page, 
        class_name: "Breeze::Content::Page", 
        inverse_of: :content_items

      attr_accessible :region, :content_type_id

      validates :region, presence: true
      validates :content_type_id, presence: true

      def method_missing(name, *args, &block)
        if self.respond_to?(name)
          read_attribute(name)
        else
          super
        end
      end

      def respond_to?(name, *args, &block)
        super || allowed_dynamic_accessors.include?(name)
      end

    private

      def allowed_dynamic_accessors
        content_type.content_fields_names.map(&:to_sym)
      end

    end
  end
end
