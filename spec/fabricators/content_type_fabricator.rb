Fabricator(:content_type, class_name: Breeze::Content::Type) do
  name 'gallery'
  content_fields { 
    [ Fabricate(:content_field,
      label: 'name',
      name: 'name',
      field_type: :text
    ), 
    Fabricate(:content_field,
      label: 'gallery_path',
      name: 'gallery_path',
      field_type: :url
    )]
  }
end
