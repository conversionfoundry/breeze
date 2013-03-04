module Breeze
  module Content
    class CustomTypeInstance
      include Mongoid::Document
      belongs_to :custom_type, class_name: "Breeze::Content::CustomType"
      field :field_value_set, type: Hash 

      #We'll use an abstract type http://mongoid.org/en/mongoid/docs/documents.html
      field :region, type: String 

      embedded_in :page, 
        class_name: "Breeze::Contet::Page", 
        inverse_of: :content_items

      attr_accessible :field_value_set

      validate :region, presence: true
    end
  end
end
