module Breeze
  module Content
    class PageView < View
      def render_as_html
        controller.instance_variable_set "@variables_for_render", variables_for_render
        controller.send :render, :inline => content.to_erb(self), :locals => variables_for_render, :layout => template
      end
    end
  end
end