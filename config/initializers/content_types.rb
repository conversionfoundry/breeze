Rails::Application.configure do
  Breeze::Content.register_class(*%w(Item NavigationItem Page Snippet Asset Image Sitemap).map { |s| "Breeze::Content::#{s}" })
end