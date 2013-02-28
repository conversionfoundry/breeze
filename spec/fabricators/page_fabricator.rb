Fabricator(:page, class_name: Breeze::Content::Page) do
  # after_create {|page| page.contents << Fabricate.build(:custom_type_instance) }
  title 'my_super_page'
  seo_title 'seo_title'
end

