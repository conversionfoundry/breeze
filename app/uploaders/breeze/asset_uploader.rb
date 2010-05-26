module Breeze
  class AssetUploader < CarrierWave::Uploader::Base
    include CarrierWave::RMagick
    
    storage :file
    
    version :thumbnail do; process :resize_to_fit => [  48,  48 ]; end
    version :small     do; process :resize_to_fit => [ 224, 224 ]; end
    
    def store_dir
      File.join *["assets", model.folder].compact
    end
  end
end