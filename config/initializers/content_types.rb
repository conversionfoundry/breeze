Rails::Application.configure do
  Breeze::Content.register_class(*%w(Item NavigationItem Page Snippet Asset Image Sitemap).map { |s| "Breeze::Content::#{s}" })
end

Rails::Application.config.to_prepare do
  Breeze::Content::Custom::StringField
  Breeze::Content::Custom::TextField
  Breeze::Content::Custom::ImageField
  
  Rails.logger.info Breeze::Content::Custom::Type.classes.inspect.green
end