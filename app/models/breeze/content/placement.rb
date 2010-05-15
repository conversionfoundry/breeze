module Breeze
  module Content
    class Placement
      include Mongoid::Document
      
      field :region
      field :view
      field :position, :type => Integer
      belongs_to_related :content, :class_name => "Breeze::Content::Item"
      embedded_in :container, :inverse_of => :placements
      
      def match?(options = {})
        (options[:region].blank? || options[:region].to_s == region) &&
        (options[:view].blank? || options[:view].to_s == region)
      end
      
      def shared?
        content.shared?
      end
      
      def to_erb(view)
        unless content.nil?
          "<div class=\"breeze-content #{content.html_class} content_#{content.id}#{" shared" if shared?}\" id=\"content_#{id}\">#{content.to_erb(view)}</div>"
        end
      end
    end
  end
end