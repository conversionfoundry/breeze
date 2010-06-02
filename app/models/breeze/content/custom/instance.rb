module Breeze
  module Content
    module Custom
      class Instance < Breeze::Content::Item
        def to_erb(view)
          begin
            view.controller.render_to_string :partial => "/partials/#{custom_type.default_template_name}", :layout => false, :locals => locals
          rescue ActionView::MissingTemplate
            custom_type.custom_fields.map do |field|
              field.to_html(view, self)
            end.join("\n")
          rescue Exception => e
            %{<div class="rendering-error"><h3>#{e.to_s}</h3><p>#{e.message}</p></div>}
          end
        end
        
        def edit_form(form)
          form.fieldset do
            custom_type.custom_fields.sort.collect do |field|
              field.editor form
            end.join("\n").html_safe
          end
        end
        
        def locals
          returning({}) do |hash|
            custom_type.custom_fields.each do |field|
              field_name = field.name.to_sym
              value = send field_name
              hash[field_name] = case value
              when String then value.html_safe
              else value
              end
            end
          end
        end
        
        def self.custom_type
          @custom_type ||= Breeze::Content::Custom::Type.where(:type_name => name.demodulize).first
        end
        def custom_type; self.class.custom_type; end
      end
    end
  end
end