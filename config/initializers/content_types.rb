Rails.application.class.configure do
  Breeze::Content.register_class(*%w(Item NavigationItem Page Snippet Asset Image Sitemap Redirect Placeholder).map { |s| "Breeze::Content::#{s}" })
  # Breeze::Content.register_class *Breeze::Content::Custom::Instance.all.map(&:type).uniq
end

Rails.configuration.to_prepare do
  Breeze::Content::Custom::StringField
  Breeze::Content::Custom::TextField
  Breeze::Content::Custom::ImageField
end
