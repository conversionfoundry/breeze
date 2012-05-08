module Breeze
  class AssetUploader < CarrierWave::Uploader::Base
    #include CarrierWave::ConditionalVersions
    include CarrierWave::RMagick
    
    storage :file
    
    def store_path(for_file = filename)
      File.join *[version_name ? "images/thumbnails/#{version_name}" : "assets", model.folder, full_filename(for_file)].compact
    end
    
    def full_filename(for_file)
      for_file
    end
  end
end
