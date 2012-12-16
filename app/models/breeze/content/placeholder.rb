# A placeholder item for extra menu structure with no linked page
# It's not ideal to inherit from NavigationItem, as we don't want permalinks and other stuff, but it saves a lot of refactoring
module Breeze
  module Content
    class Placeholder < NavigationItem

      def link_to
        first_children.try(:link_to) || 'javascript:void(0)'
      end

      def editable?
        true
      end

    end
  end
end
