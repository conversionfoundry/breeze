Rails::Application.configure do
  Breeze::Content.register_class(*%w(Item NavigationItem Page Snippet).map { |s| "Breeze::Content::#{s}" })
end