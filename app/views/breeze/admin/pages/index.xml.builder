xml.instruct!
xml.pages do
  Breeze::Content::NavigationItem.all.order_by([[ :permalink, :asc]]).each do |page|
    xml.url do
      xml.id          page.id
      xml.title       page.title
      xml.permalink   page.permalink
    end
  end
end