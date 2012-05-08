Rails.application.class.configure do
  Breeze::Content.register_class(*%w(Item NavigationItem Page Snippet Asset Image Sitemap Redirect).map { |s| "Breeze::Content::#{s}" })
end

Rails.configuration.to_prepare do
  Breeze::Content::Custom::StringField
  Breeze::Content::Custom::TextField
  Breeze::Content::Custom::ImageField
end
