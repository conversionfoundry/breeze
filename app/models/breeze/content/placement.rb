module Breeze
  module Content
    class Placement
      field :region
      field :view
      belongs_to_related :content, :class_name => "Breeze::Content::Item"
      embedded_in :container, :inverse_of => :placements
      
      def match?(options = {})
        (options[:region].blank? || options[:region].to_s == region) &&
        (options[:view].blank? || options[:view].to_s == region)
      end
    end
  end
end