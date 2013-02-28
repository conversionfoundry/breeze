module Breeze
  module Content
    class Item
      include Mongoid::Document
      include Mongoid::Timestamps
      include ActiveModel::Serializers::Xml
      include Mixins::Markdown

      field :template
      
      attr_protected :_id

      index({parent_id: 1, _type: 1})
      
      alias_method :type, :_type
      
      
    private
      
    end
  end
end
