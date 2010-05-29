module Breeze
  module Content
    class Image < Asset
      field :image_width,  :type => Integer
      field :image_height, :type => Integer

      attr_accessor :crop

      mount_uploader :file, ImageUploader, :mount_on => :file

      before_update :reprocess_file
      
      def image?
        true
      end
      
    protected
      def reprocess_file
        if image? && !@crop.blank?
          target_width, target_height = @crop[:target_width].to_i, @crop[:target_height].to_i
          if target_width > 0 && target_height > 0 && (target_width < image_width || target_height || image_height)
            w, h = image_width, image_height
            
            file.manipulate! do |img|
              if r = selection_rect
                img.crop! r[:x], r[:y], r[:width], r[:height]
                w, h = r[:width], r[:height]
              end
              
              if target_width > 0 && target_height > 0 && (w > target_width || h > target_height)
                if @crop[:mode].to_s == "resize_to_fit" then
                  img.resize_to_fit! target_width, target_height
                else
                  img.resize_to_fill! target_width, target_height
                end
              end
              
              write_attribute :image_width, img.columns
              write_attribute :image_height, img.rows
              
              img
            end
            
            file.versions.each do |name, v|
              v.cache! file.file
              v.store!
            end
          end
        end
      end
      
      def selection_rect
        returning({}) do |rect|
          %w(selection_x selection_y selection_width selection_height).each do |k|
            return false if @crop[k.to_sym].blank?
            rect[k.sub(/^selection_/, '').to_sym] = @crop[k.to_sym].to_i
          end
        end
      end
    end
  end
end