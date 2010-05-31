module Breeze
  module Content
    class Asset < Item
      field :title
      field :description
      field :file
      field :folder
      
      attr_accessor :basename
      
      mount_uploader :file, AssetUploader, :mount_on => :file
      
      before_update :rename_file
      
      def image?
        false
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
      
      def self.file_mask
        /.*$/
      end
      
      def self.===(filename)
        case filename
        when String then file_mask === filename
        else super
        end
      end
            
      def self.from_upload(params = {})
        klass = subclasses.map(&:constantize).detect { |k| k === params[:Filename] } || self
        klass.new :file => params[:file], :folder => params[:folder]
      end
      
      def self.folders
        root = File.join Rails.root, "public", "assets"
        ["/"] + Dir.glob(File.join(root, "**/*")).select { |f| File.directory?(f) }.map { |f| f[root.length..-1] }
      end
      
    protected
      def all_files
        [ file.path ] + file.versions.values.map { |f| File.join(Rails.root, "public", f.to_s) }
      end
    
      def rename_file
        if !@basename.blank? && @basename != attributes[:file]
          @basename += "." + extension unless /\.\w+/ === @basename
          all_files.each do |src|
            dest = src.sub /#{path}$/, @basename
            FileUtils.mv src, dest if src != dest
          end
          write_attribute :file, @basename
          @_mounters[:file] = nil
          @basename = nil
        end
      end
    end
  end
end

require File.join(File.dirname(__FILE__), "image.rb")