module Breeze
  module Content
    class Placement
      include Mongoid::Document
      
      field :region, :type => String
      field :view
      field :position, :type => Integer, :default => 0
      belongs_to :content, :class_name => "Breeze::Content::Item"
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
        # TODO: We've beeng getting weird errors on smartmoves.leftclick.co.nz, where placements can't find their related content items. This begin..rescue block is a workaround, not a solution.
        begin
          binding.pry
          content_id = content.new? ? "content_new" : "content_" + content.id.to_s
          content_block = "<div class=\"breeze-content #{content.html_class} #{content_id} #{"shared" if shared?}\" id=\"content_#{content.new? ? "new" : id}\">#{content.to_erb(view)}</div>"
        rescue
          raise "Error: Unknown content"
        end
        content_block
      end
      
      def duplicate(container)
        content.add_to_container container, region, view, position + 1
      end
      
      def unlink!
        decrement_content_placement_count
        self.content_id = self.content.duplicate({ :placements_count => 1 }).id
        self.content = Breeze::Content::Item.find self.content_id
        save
        self
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
        begin
          if content
            content.placements_count -= 1
            if content.placements_count.zero?
              content.destroy
            elsif content.placements_count > 0
              content.save
            end
          end
        rescue Mongoid::Errors::DocumentNotFound
        end
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
