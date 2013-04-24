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
    page_id = params.fetch(:content_type_instance).delete(:page_id)
    if Breeze::Content::Page.find(page_id).content_items.create(
      params.fetch(:content_type_instance)
    )
      notice = 'Content created successfully.'
    else
      notice = 'Content creation failed.'
    end
  end

end
