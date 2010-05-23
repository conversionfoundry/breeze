module Breeze
  module Content
    class Placement
      include Mongoid::Document
      
      field :region
      field :view
      field :position, :type => Integer, :default => 0
      belongs_to_related :content, :class_name => "Breeze::Content::Item"
      embedded_in :container, :inverse_of => :placements
      
      before_create :set_position
      after_create  :increment_content_placement_count
      after_destroy :decrement_content_placement_count
      
      def <=>(another)
        position <=> another.position
      end
      
      def match?(options = {})
        (options[:region].blank? || options[:region].to_s == region) &&
        (options[:view].blank? || view.nil? || options[:view].to_s == view)
      end
      
      def shared?
        content.shared?
      end
      
      def to_erb(view)
        unless content.nil?
          "<div class=\"breeze-content #{content.html_class} content_#{content.id}#{" shared" if shared?}\" id=\"content_#{id}\">#{content.to_erb(view)}</div>"
        end
      end
      
    protected
      def set_position
        if container
          existing = container.placements.for(:view => view, :region => region)
          self.position ||= existing.count - 1 # -1 for self
          existing.each { |p| p.position += 1 if p != self && p.position >= position }
        end
      end
    
      def increment_content_placement_count
        update_content_placement_count 1
      end
      
      def decrement_content_placement_count
        update_content_placement_count -1
      end
      
      def update_content_placement_count(by = 1)
        Breeze::Content::Item.collection.update(
          { :_id => content_id },
          { '$inc' => { :placements_count => by } }
        )
      end
    end
  end
end