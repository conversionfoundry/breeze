module Breeze
  module Content
    class TypeInstance
      include Mongoid::Document

      # We'll use an abstract type
      # http://mongoid.org/en/mongoid/docs/documents.html
      field :field_value_set, type: Hash 
      field :region, type: String 

      belongs_to :type, 
        class_name: "Breeze::Content::Type"
      embedded_in :page, 
        class_name: "Breeze::Content::Page", 
        inverse_of: :content_items

      attr_accessible :field_value_set, :region

      validates :region, presence: true
    end
  end
end
