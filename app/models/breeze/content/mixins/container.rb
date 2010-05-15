module Breeze
  module Content
    module Mixins
      module Container
        def self.included(base)
          base.embeds_many :placements, :class_name => "Breeze::Content::Placement" do
            def for(options = {})
              @target.select { |p| p.match?(options) }
            end
          end
          base.accepts_nested_attributes_for :placements, :reject_if => lambda { |v| v[:delete].present? }
        end
        
        def to_erb(view)
          returning("") do |str|
            placements.for(:view => view).group_by(&:region).each do |region, placements|
              str << "<% content_for_region :#{region.to_sym} do %>\n"
              placements.each do |placement|
                str << placement.to_erb(view)
              end
              str << "<% end %>\n"
            end
          end
        end
        
        module ClassMethods
        end
      end
    end
  end
end