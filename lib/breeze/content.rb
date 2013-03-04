module Breeze
  module Content
    
    def self.[](permalink)
      # Allow plugins to provide content
      content = Breeze.run_hook(:get_content_by_permalink, permalink)
      # Otherwise, look for page in Breeze Core
      if content.blank? || content.is_a?(String)
        content = Page.where(permalink: permalink).first 
      end
      content
    end
    
  end
end
