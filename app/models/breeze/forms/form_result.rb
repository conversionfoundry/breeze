module Breeze
  module Forms
    class FormResult
      include Mongoid::Document
      include Mongoid::Timestamps

      attr_accessible :serialized_form_values, :form_name
      field :serialized_form_values, type: Hash
      field :form_name

    end
  end
end
