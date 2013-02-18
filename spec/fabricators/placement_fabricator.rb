Fabricator(:placement, class_name: Breeze::Content::Placement) do
  content { Fabricate :snippet }
  position 1
  region 'main_region'
end
