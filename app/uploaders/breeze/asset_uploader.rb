module Breeze
  class AssetUploader < CarrierWave::Uploader::Base
    include CarrierWave::ConditionalVersions
    include CarrierWave::RMagick
    
    storage :file
    
    # TODO: make these conditional
    version :icon,      :if => :image? do; process :resize_to_fit   => [  48,  48 ]; end
    version :thumbnail, :if => :image? do; process :resize_to_limit => [ 128, 128 ]; end
    version :preview,   :if => :image? do; process :resize_to_limit => [ 224, 224 ]; end
    
    def store_path(for_file = filename)
      File.join *[version_name ? "images/thumbnails/#{version_name}" : "assets", model.folder, full_filename(for_file)].compact
    end
    
    def full_filename(for_file)
      for_file
    end
    
    before :cache, :capture_size_before_cache 
    before :retrieve_from_cache, :capture_size_after_retrieve_from_cache 

    def capture_size_before_cache(new_file)
      model.image_width, model.image_height = `identify -format "%wx %h" #{new_file.path}`.split(/x/) if image?(new_file.path)
    end
    
    def capture_size_after_retrieve_from_cache(cache_name)
      model.image_width, model.image_height = `identify -format "%wx %h" #{@file.path}`.split(/x/) if image?(@file.path)
    end
    
    def image?(path = nil)
      path ||= @file.path
      path = path.path if path.respond_to?(:path)
      !!(/^image\// === Mime[File.extname(path)[1..-1].downcase].to_s)
    end
  end
end