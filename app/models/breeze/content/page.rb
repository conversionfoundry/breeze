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

      attr_accessible :title, :subtitle, :template, :ssl, :seo_title,
        :seo_meta_keywords, :seo_meta_description, :show_in_navigation,
        :parent_id

      validates :title, presence: true
      validates :template, presence: true

      index({ parent_id: 1, slug: 1 }, { unique: true })

      embeds_many :content_items, 
        class_name: "Breeze::Content::TypeInstance",
        inverse_of: :page

      def self.[](permalink)
        where(permalink: permalink).first
      end

      # List existing templates
      # => ['_default', '_landing_page']
      PAGE_TEMPLATES_PATH = "vendor/themes/template/partials/*"
      def self.templates
        Dir[PAGE_TEMPLATES_PATH].map { |file| File.basename(file, '.html.erb') }
      end
      
      def page_title
        seo_title.presence || title
      end

      def to_s
        page_title
      end

      def duplicate
        duplicata = clone
        duplicata.save
        duplicata
      end
            
    end
  end
end
