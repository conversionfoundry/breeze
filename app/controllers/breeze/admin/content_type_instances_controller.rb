class Breeze::Admin::ContentTypeInstancesController < Breeze::Admin::AdminController
  respond_to :js

  def new
    content_for = params.fetch(:content)
    page = Breeze::Content::Page.find(content_for.fetch(:page_id))
    @instance = page.content_items.build(
      region: content_for.fetch(:region),
      type: Breeze::Content::Type.first, # default
      field_value_set: {}
    )
  end

  def create
    page_id = params.fetch(:page_id)
    region = params.fetch(:region)
    type_id = params.fetch(:type_id)
    field_value_set = params.fetch(:field_value_set)

    Breeze::Content::Page.find(page_id).instances.create(
      region: region,
      type_id: type_id,
      field_value_set: field_value_set
    )
  end

end
