module Breeze
  module Content
    class PageView < View
      def render_as_html
        controller.send :render, :text => "Hello world"
      end
    end
  end
end