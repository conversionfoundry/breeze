module Breeze
  module Content
    module Custom
      class TextField < Field
        def self.label
          "Text (multi-line)"
        end

        def define_on(klass)
          klass.field name, :markdown => true
        end

        def editor(form)
          form.text_area name.to_sym, :label => label, :rows => 8, :class => "markup"
        end
      end
    end
  end
end