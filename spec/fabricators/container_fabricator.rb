Fabricator(:container, from: Breeze::Content::Page) do
  content
  position 1
  region 'region'
  view
end
