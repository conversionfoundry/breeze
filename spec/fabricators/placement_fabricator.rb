Fabricator(:placement, from: Breeze::Content::Placement) do
  content
  position 1
  region 'region'
  view
end
