module Breeze
  module Content
    class Asset < Item
      unloadable
      
      field :title
      field :file
      field :folder
      field :image_width,  :type => Integer
      field :image_height, :type => Integer
      
      mount_uploader :file, AssetUploader, :mount_on => :file
      
      def image?
        !!(file && /^image\// === Mime[extension].to_s)
      end
      
      def basename
        attributes[:file]
      end
      
      def extension
        File.extname(file.path)[1..-1].downcase
      end
    end
  end
end