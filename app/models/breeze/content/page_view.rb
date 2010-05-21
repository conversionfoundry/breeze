module Breeze
  module Content
    class PageView < View
      unloadable
      
      def render_as_html
        controller.instance_variable_set "@variables_for_render", variables_for_render
        controller.send :render, :inline => content.to_erb(self), :locals => variables_for_render, :layout => template
      end
      
      def editor_html
        <<-HTML
          <script type="text/javascript">
            // Breeze content editing
            if (typeof(jQuery) == 'undefined') { document.write('<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></s' + 'cript>'); }
            if (typeof(jQuery) == 'undefined' || typeof(jQuery.ui) == 'undefined') { document.write('<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js"></s' + 'cript>'); }
            document.write('<script type="text/javascript" src="/breeze/javascripts/rails.js"></s' + 'cript>');
            document.write('<script type="text/javascript" src="/breeze/editor/editor.js"></s' + 'cript>');
            document.write('<script type="text/javascript" defer="defer">$(function() {');
            document.write('$("body").breeze({ page_id:"#{content.id}", templates:#{Breeze::Theming::Theme.available_templates.inspect} });');
            #{"document.write('$(\"#breeze-template-chooser\").val(\"#{content.template}\")');" if content.template?}
            document.write('});</s' + 'cript>');
          </script>
        HTML
      end
    end
  end
end