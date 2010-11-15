module Breeze
  module Admin
    module ThemesHelper
      def file_tree(files, options = {})
        options[:filename] ||= :to_s
        options[:root] ||= ""
        options[:folder] ||= options[:root]
        options[:href] ||= lambda { |s| s }
        this_dir = /^#{options[:folder]}\/([^\/]+)$/
        
        returning "" do |str|
          files.map(&options[:filename]).each do |filename|
            if this_dir === filename
              path = filename[options[:root].length..-1]
              basename = File.basename(filename)
              if File.directory?(filename)
                is_special = %w(images layouts stylesheets javascripts).include?(path.sub(/^\//, ''))
                str << "<li class=\"folder #{basename.gsub(/[^\w]+/, "-")}\" rel=\"#{is_special ? :special : :folder}\"><a href=\"#{options[:href].call(path)}\"><ins class=\"icon\"></ins>#{basename}</a>"
                child_folder = File.join(options[:folder], basename)
                child_files = files.select { |f| /^#{child_folder}\// === f }
                str << content_tag(:ul, file_tree(child_files, options.merge(:folder => child_folder))) unless child_files.empty?
                str << "</li>"
              else
                str << "<li class=\"file #{File.extname(filename)[1..-1]}\" rel=\"file\"><a href=\"#{options[:href].call(path)}\"><ins class=\"icon\"></ins>#{basename}</a></li>"
              end
            end
          end
        end.html_safe
      end

      def image_file?(path)
        Mime[File.extname(path)[1..-1]].to_s =~ /^image\//
      end

      def folder_description(&block)
        content_tag :div, :class => "folder-description", &block
      end
    end
  end
end