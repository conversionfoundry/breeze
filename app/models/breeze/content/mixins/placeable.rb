module Breeze
  module Content
    module Mixins
      module Placeable
        def self.included(base)
          base.extend ClassMethods

          base.class_eval do
            field :placements_count, :type => Integer, :default => 0
  
            attr_accessor :container_id
            attr_accessor :region
            attr_accessor :view
            attr_reader :placement
            
            after_create :add_to_container
            after_destroy :destroy_placements
          end
        end
        
        def self.classes
          Breeze::Content::Custom::Type.all.map(&:to_class)
          Content.classes(self)
        end

        def shared?
          placements_count > 1
        end

        def add_to_container(container = nil, region = nil, view = nil, position = nil)
          container ||= Breeze::Content::Item.find(@container_id) if @container_id
          region = @region if region.blank?
          view = @view || "default" if view.blank?
          if container && region && view
            @placement = container.placements.create(:region => region, :view => view, :position => position, :content_id => self.id)
          else
            false
          end
        end
        
        def containers
          Breeze::Content::Item.where('placements.content_id' => id).uniq
        end
        
        def placements
          containers.map { |c| c.placements.select { |p| p.content_id == id } }.flatten.uniq
        end
        
        module ClassMethods
          
        end
        
      protected
        def destroy_placements
          containers.each do |container|
            container.placements.each { |p| p.destroy if p.content_id == id }
          end
        end
      end
    end
  end
end
