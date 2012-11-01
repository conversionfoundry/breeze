module Breeze
  module Content
    class Snippet < Item
      field :content, :markdown => true
      attr_protected :_id

      include Mixins::Placeable
      
      def to_erb(view)
        content
      end
    end
  end
end
