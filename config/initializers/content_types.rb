Rails::Application.configure do
  Breeze::Content.register_class(*%w(Item NavigationItem Page Snippet Asset Image).map { |s| "Breeze::Content::#{s}".constantize })
end