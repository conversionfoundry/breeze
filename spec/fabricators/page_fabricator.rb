Fabricator(:page, class_name: Breeze::Content::Page) do
  after_create {|container| container.placements << Fabricate.build(:placement) }
  title 'page'
end

