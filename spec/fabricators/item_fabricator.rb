Fabricator(:item, class_name: Breeze::Content::Item) do
  template 'default'
end

Fabricator(:page, class_name: Breeze::Content::Page) do
  after_create {|container| container.placements << Fabricate.build(:placement) }
  title 'page'
end

Fabricator(:snippet, class_name: Breeze::Content::Snippet) do
  content 'abcdefgh'
end
