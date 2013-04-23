class Breeze::Admin::ContentTypeInstancesController < 
  Breeze::Admin::AdminController
  respond_to :js, only: [:create]

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
    content_type = params.fetch(:content_type)
    content_type_id = content_type.fetch(:id)
    content_type_content =  content_type.fetch(:content)
    if Breeze::Content::Page.find(page_id).content_items.create(
      { 
        region: region,
        content_type_id: content_type_id 
      }.merge(content_type_content)
    )
      notice = 'Content created successfully.'
    else
      notice = 'Content creation failed.'
    end
  end

end
