module Breeze
  module Admin
    module AssetsHelper
      def options_for_asset_folder_select(parent_folder)
        folders = Breeze::Content::Asset.folders
        folders.collect! do |folder| 
          option_attributes = {value: folder.html_safe}
          option_attributes.merge!({selected: 'selected'}) if folder == parent_folder
          content_tag :option, option_attributes do
            display_name = 'assets' + folder.html_safe
            folder == "/" ? display_name : display_name + "/"
          end
        end
        folders.join ""
      end
    end
  end
end
