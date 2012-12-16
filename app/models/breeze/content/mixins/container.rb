module Breeze
  module Content
    module Mixins
      module Container
        def self.included(base)
          base.embeds_many :placements, :class_name => "Breeze::Content::Placement" do
            def for(options = {})
              @target.select { |p| p.match?(options) }.sort_by { |p| p.position || -1 }
            end

            def by_id(id)
              @target.detect { |p| p.id.to_s == id.to_s }
            end
          end
          base.accepts_nested_attributes_for :placements, :reject_if => lambda { |v| v[:delete].present? }
          base.before_destroy :destroy_placements
        end
        
        def to_erb(view)
          ""
        end
        
        def order=(values)
          values.each_pair do |region_name, ids|
            ids.each_with_index do |id, i|
              if (p = placements.by_id(id)).present?
                p.position = i
                p.region = region_name
                p.save
              end
            end
          end
        end
        
        def duplicate
          new_record = self.dup
          super { new_record }.tap do |new_item|
            placements.each { |p| p.content.add_to_container new_item, p.region, p.view, p.position }
          end
        end
        
        module ClassMethods
        end
        
      protected
        def destroy_placements
          placements.destroy_all
        end
      end
    end
  end
end
