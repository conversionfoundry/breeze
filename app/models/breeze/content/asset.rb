module Breeze
  module Content
    class Asset < Item
      unloadable
      
      attr_accessor :basename
      attr_accessor :crop
      
      field :title
      field :description
      field :file
      field :folder
      field :image_width,  :type => Integer
      field :image_height, :type => Integer
      
      mount_uploader :file, AssetUploader, :mount_on => :file
      
      before_update :process_and_rename_file
      
      def image?
        !!(file && /^image\// === Mime[extension].to_s)
      end
      
      def basename
        @basename || attributes[:file]
      end
      
      def basename=(value)
        @basename = value
      end
      
      def extension
        File.extname(file.path)[1..-1].downcase
      end
      
      def path
        File.join [folder, attributes[:file]].compact
      end
      
    protected
      def all_files
        [ file.path ] + file.versions.values.map { |f| File.join(Rails.root, "public", f.to_s) }
      end
    
      def process_and_rename_file
        unless @basename.blank? && @basename != attributes[:file]
          @basename += "." + extension unless /\.\w+/ === @basename
          all_files.each do |src|
            dest = src.sub /#{path}$/, @basename
            FileUtils.mv src, dest if src != dest
          end
          write_attribute :file, @basename
          @_mounters[:file] = nil
          @basename = nil
        end
        
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