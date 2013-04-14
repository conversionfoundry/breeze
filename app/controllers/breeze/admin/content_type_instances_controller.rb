class Breeze::Admin::ContentTypeInstancesController < Breeze::Admin::AdminController
  # respond_to :js

  def new
    content_for = params.fetch(:content)
    page = Breeze::Content::Page.find(content_for.fetch(:page_id))
    @instance = page.content_items.build(
      region: content_for.fetch(:region),
      content_type: Breeze::Content::Type.first # default
    )
  end

  def create
    page_id = params.fetch(:page_id)
    region = params.fetch(:region)
    content_type_id = params.fetch(:type_id)

    Breeze::Content::Page.find(page_id).instances.create(
      region: region,
      content_type_id: content_type_id
    )
  end

end
