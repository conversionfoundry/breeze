module Breeze
  module Content
    module Custom
      class DateField < Field

        def self.label
          "Date"
        end

        def editor(form)
          form.fields_for "datefield" do
            form.date_select name.to_sym, :label => label
            # form.text_field "datefield_#{name}".to_sym, (Time.now).strftime("%a %e %b, %Y")
          end
        end

        def to_html(view, instance)
          "<div class=\"#{name}\">#{instance.send name.to_sym}</div>"
        end

      end
    end
  end
end