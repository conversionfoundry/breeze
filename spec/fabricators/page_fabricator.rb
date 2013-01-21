Fabricator(:page, class_name: Breeze::Content::Page) do
  after_create {|container| container.placements << Fabricate.build(:placement) }
  after_create {|page| page.permalink = 'permalink_page' }
  title 'page'
end

