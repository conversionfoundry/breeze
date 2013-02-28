module Breeze
  module Content
    class CustomTypeInstance
      include Mongoid::Document
      belongs_to :custom_type, class_name: "Breeze::Content::CustomType"
      field :field_value_set, type: Hash #Actually we will use an abstract type http://mongoid.org/en/mongoid/docs/documents.html
      field :region, type: String 

      attr_accessible :field_value_set

    end
  end
end
