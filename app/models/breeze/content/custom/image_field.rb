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
      end
    end
  end
end