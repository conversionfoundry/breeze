module Breeze
  module Content
    class TypeInstance
      include Mongoid::Document
      # In this model we use dynamic fields to store the set of values 
      # Read this http://mongoid.org/en/mongoid/docs/documents.html#dynamic_fields 
      # For example in the view if the form does something like
      # form_for instance do |form|
      #   form.text_field :url
      # end
      # The related object will have an attribute set. However no setter/getter
      # is generated

      field :region, type: String 

      belongs_to :content_type, 
        class_name: "Breeze::Content::Type"
      embedded_in :page, 
        class_name: "Breeze::Content::Page", 
        inverse_of: :content_items

      attr_accessible :region, :content_type

      validates :region, presence: true

      def name 
        read_attribute(:name)
      end

      def name=(arg)
        write_attribute(:name)
      end

      def url
        read_attribute(:name)
      end

      def url=(arg)
        write_attribute(:name)
      end

      def options
        read_attribute(:name)
      end

      def options=(arg)
        write_attribute(:name)
      end
    end
  end
end
