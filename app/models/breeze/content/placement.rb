module Breeze
  module Content
    class Placement
      include Mongoid::Document
      field :_id, type: String, default: -> { Moped::BSON::ObjectId.new.to_s }
      field :region, :type => String
      field :view
      field :position, :type => Integer, :default => 0
      
      attr_protected :id

      belongs_to :content, :class_name => "Breeze::Content::Item"
      embedded_in :container, :inverse_of => :placements

      before_validation :set_position
      after_create  :increment_content_placement_count
      after_destroy :decrement_content_placement_count

      validates :position, numericality: { greater_than_or_equal_to: 0 }, presence: true
      
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
        content_id = !content.new_record? ? "content_new" : "content_" + content.id.to_s
        content_classes = "breeze-content #{content.html_class} #{content_id} #{'shared' if shared?}"
        if content.is_a? Breeze::Content::Custom::Instance
          content_classes += " breeze-content-custom"
          content_classes += " breeze-content-custom-no_fields" if content.custom_type.custom_fields.empty?
        end
        "<div class=\"#{content_classes}\" id=\"content_#{content.new_record? ? "new" : id}\">#{content.to_erb(view)}</div>"
      end
      
      def duplicate(container)
        content.add_to_container(container, region, view, position.to_i + 1)
      end
      
      def unlink!
        self.tap do
          self.content = self.content.duplicate({ :placements_count => 1 })
          save
        end
      end
      
    protected
      def set_position
        if container
          existing = container.placements.for(:view => view, :region => region)
          self.position ||= existing.count - 1 # -1 for self
          existing.each { |p| p.position += 1 if p != self && p.position >= position }
        else
          self.position ||= 0
        end
      end
    
      def increment_content_placement_count
        update_content_placement_count 1
      end
      
      def decrement_content_placement_count
        if content
          content.placements_count -= 1
          if content.placements_count.zero?
            content.destroy
          elsif content.placements_count > 0
            content.save
          end
        end
      end
      
      def update_content_placement_count(by = 1)
        # Breeze::Content::Item.collection.update(
        #   { :_id => content_id },
        #   { '$inc' => { :placements_count => by } }
        # )
        Breeze::Content::Item.where(:_id => content_id).inc(:placements_count, 1)
      end
    end
  end
end
