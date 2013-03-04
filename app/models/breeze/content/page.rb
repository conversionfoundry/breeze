module Breeze
  module Content
    class Page
      include Mongoid::Document
      include Mongoid::Timestamps
      include Mongoid::Paranoia
      include Mixins::TreeStructure
      include Mixins::Permalinks
      include Mixins::Markdown
      
      field :title, type: String
      field :subtitle, type: String
      field :template, type: String, default: 'default'
      field :ssl, type: Boolean, default: false
      field :seo_title, type: String
      field :seo_meta_description, type: String
      field :seo_meta_keywords, type: String
      field :show_in_navigation, type: Boolean, default: true

      validates :title, presence: true
      validates :template, presence: true

      index({ parent_id: 1, slug: 1 }, { unique: true })

      embeds_many :content_items, 
        class_name: "Breeze::Content::CustomTypeInstance",
        inverse_of: :page

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
