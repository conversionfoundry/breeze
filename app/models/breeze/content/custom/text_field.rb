module Breeze
  module Content
    module Custom
      class TextField < Field
        field :rows, :type => Integer, :default => 8
        
        def self.label
          "Text (multi-line)"
        end

        def define_on(klass)
          klass.field name, :markdown => true
        end

        def editor(form)
          form.text_area name.to_sym, :label => label, :rows => rows, :class => "markup"
        end
        
        def rows
          self[:rows] || 8
        end
      end
    end
  end
end