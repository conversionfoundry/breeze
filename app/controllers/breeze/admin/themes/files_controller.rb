module Breeze
  module Admin
    module Themes
      class FilesController < Breeze::Admin::AdminController
        def index

        end
        
      protected
        def theme
          @theme ||= Breeze::Theming::Theme[params[:theme_id]]
        end
        helper_method :theme
      end
    end
  end
end