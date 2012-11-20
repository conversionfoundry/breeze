module Breeze
  module Content
    class PageView < Breeze::Content::View
      def page
        content
      end
      
      def render_as_html
        controller.instance_variable_set "@variables_for_render", variables_for_render
        # TODO: catch the missing template error if the template isn't available.
        # We should at least be able to render :layout => "page" with the built-in views.
        controller.send :render, :inline => content.to_erb(self), :locals => variables_for_render, :layout => template
      end
      
      def editor_html
        <<-HTML
          <script type="text/javascript">

            document.write('<script type="text/javascript" defer="defer">$(function() {');
            document.write('$("body").breeze({ page_id:"#{content.id}", view:"#{self.name}", views:#{(content.views.empty? ? %w(default) : content.views.map(&:name)).inspect}, template:"#{content.template}", templates:#{Breeze::Theming::Theme.available_templates.inspect} });');
            #{"document.write('$(\"#breeze-template-chooser\").val(\"#{content.template}\")');" if content.template?}
            document.write('});</s' + 'cript>');
          </script>
        HTML
      end
    end
  end
end

