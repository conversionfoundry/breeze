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
      attr_accessor :ola

      validates :region, presence: true
      validates :content_type_id, presence: true

    end
  end
end
