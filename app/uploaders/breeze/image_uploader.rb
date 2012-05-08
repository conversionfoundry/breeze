module Breeze
  class ImageUploader < AssetUploader
    version :icon do; process :resize_to_fit   => [  48,  48 ]; end
    version :thumbnail do; process :resize_to_limit => [ 128, 128 ]; end
    version :preview   do; process :resize_to_limit => [ 224, 224 ]; end
    
    before :cache, :capture_size_before_cache 
    before :retrieve_from_cache, :capture_size_after_retrieve_from_cache 

  protected
    def capture_size_before_cache(new_file)
      capture_image_size!(new_file.path || new_file.file.tempfile.path)
    end
  
    def capture_size_after_retrieve_from_cache(cache_name)
      Rails.logger.info @file.path.inspect.blue
      capture_image_size!(@file.path)
    end
    
    def capture_image_size!(path)
      model.image_width, model.image_height = `identify -format "%wx%h" #{path}`.split(/x/)
    end
  end
end
