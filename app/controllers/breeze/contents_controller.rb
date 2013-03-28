module Breeze
  class ContentsController < Controller
    layout :select_default_layout

    def show
      path = "/" << params[:permalink].to_s
      # TODO add the redirection code here 
      @page = Breeze::Content[path] or raise Breeze::Errors::NotFound, request
      render file: set_file_to_render(page)
    end

    def page
      @page
    end
    helper_method :page # Convenient accessibility into templates

    private 

    # This could be reopened and modified into the customer application to
    # point at specific files 
    def select_default_layout
      current_admin.present? ? 'editor' : 'visitor'
    end

    # Yielded into the layout
    def set_file_to_render(page)
      'vendor/themes/template/partials/_'.tap do |s|
        s << (page.template || 'default')
      end
    end

  end
end
