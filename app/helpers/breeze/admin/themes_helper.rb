module Breeze
  module Admin
    module ThemesHelper
      def file_tree(files, options = {})
        options[:filename] ||= :to_s
        options[:root] ||= ""
        options[:folder] ||= options[:root]
        options[:href] ||= "%s"
        this_dir = /^#{options[:folder]}\/([^\/]+)$/
        
        returning "" do |str|
          files.map(&options[:filename]).each do |filename|
            if this_dir === filename
              path = filename[options[:root].length..-1]
              basename = File.basename(filename)
              if File.directory?(filename)
                str << "<li class=\"folder #{basename}\"><a href=\"#{options[:href] % path}\">#{basename}</a>"
                str << content_tag(:ul, file_tree(files, options.merge(:folder => File.join(options[:folder], basename))))
                str << "</li>"
              else
                str << "<li class=\"file #{File.extname(filename)[1..-1]}\"><a href=\"#{options[:href] % path}\">#{basename}</a></li>"
              end
            end
          end
        end.html_safe
      end
    end
  end
end