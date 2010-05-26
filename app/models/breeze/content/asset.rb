module Breeze
  module Content
    class Asset < Item
      field :file
      field :folder
      
      mount_uploader :file, AssetUploader
    end
  end
end