module Breeze
  module Content
    module Custom
      class ImageField < Field
        field :width, :type => Integer
        field :height, :type => Integer
        
        def define_on(klass)
          klass.field name, :markdown => true
        end
        
        def to_html(view, instance)
          src = instance.send name.to_sym
          src && "<img src=\"#{src}\" />"
        end
        
        def editor(form)
          form.text_field name.to_sym, :label => sized_label, :wrap => { :class => "image_field" }, :after => "<a class=\"browse\" href=\"#\">Browse</a>".html_safe
        end
        
        def sized_label
          "#{label}#{" (#{width} &times; #{height})" if width && height}".html_safe
        end
        
      end
    end
  end
end