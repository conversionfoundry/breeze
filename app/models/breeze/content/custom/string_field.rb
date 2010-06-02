module Breeze
  module Content
    module Custom
      class StringField < Field
        def self.label
          "Text (single line)"
        end
      end
    end
  end
end