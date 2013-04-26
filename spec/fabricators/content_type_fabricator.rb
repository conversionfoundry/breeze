Fabricator(:content_type, class_name: Breeze::Content::Type) do
  name 'content type'
end

Fabricator(:gallery, class_name: Breeze::Content::Type) do
  name 'gallery'
  content_fields do |content_type| 
    content_type.content_fields << 
      [ 
      Fabricate(:content_field, 
        content_type: content_type,
        label: 'name', 
        name: 'name', 
        field_type: :text),
      Fabricate(:content_field, 
        content_type: content_type,
        label: 'gallery_path', 
        name: 'gallery_path',
        field_type: :url)
      ]
  end
end
