Fabricator(:placement, class_name: Breeze::Content::Placement) do
  content { Fabricate.build :snippet }
  position 1
  region 'region'
end
