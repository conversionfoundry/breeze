Fabricator(:page, class_name: Breeze::Content::Page) do
  after_create {|container| container.placements << Fabricate.build(:placement) }
  title 'my_super_page'
end

