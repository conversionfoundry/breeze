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
        end
        
        module ClassMethods
        end
      end
    end
  end
end