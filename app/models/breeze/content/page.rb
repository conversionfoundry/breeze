module Breeze
  module Content
    class Page
      include Mongoid::Document
      include Mixins::TreeStructure
      include Mixins::Permalinks
      include Mixins::Markdown
      
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

      embeds_many :contents
      
      def to_s
        title
      end
      
      # This has to move into ActiveSupport::Notifications
      after_create  { |page| Breeze::Admin::Activity.log :create, page }
      after_update  { |page| Breeze::Admin::Activity.log :update, page }
      before_destroy { |page| Breeze::Admin::Activity.log :delete, page }
      
      def page_title
        seo_title.presence || title
      end
            
      def self.[](permalink)
        where(permalink: permalink).first
      end

    end
  end
end
