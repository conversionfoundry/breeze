module Breeze
  module Content
    class Page
      include Mongoid::Document
      include Mongoid::Timestamps
      include Mongoid::Paranoia

      # include Mixins::TreeStructure
      # include Mixins::Permalinks
      # include Mixins::Markdown
      
      field :title
      field :subtitle
      field :template, default: 'default'
      field :ssl, :type => Boolean, :default => false
      field :seo_title
      field :seo_meta_description
      field :seo_meta_keywords
      field :show_in_navigation, :type => Boolean, :default => true

      validates :title, presence: true
      validates :template, presence: true

      index({ parent_id: 1, slug: 1 }, { unique: true })

      embeds_many :content_items, class_name: "Breeze::Content::CustomTypeInstance"

      def self.[](permalink)
        where(permalink: permalink).first
      end
      
      def page_title
        seo_title.presence || title
      end

      def to_s
        page_title
      end
            
    end
  end
end
