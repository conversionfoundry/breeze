module Breeze
  module Content
    class NavigationItem < Item
      include Mongoid::Document
      include Mixins::TreeStructure
      include Mixins::Permalinks
      
      field :title
      field :subtitle
      field :show_in_navigation, :type => Boolean, :default => true
      field :ssl, :type => Boolean, :default => false

      attr_protected :_id

      validates :title, presence: true

      index({ parent_id: 1, slug: 1 }, { unique: true })

      # Some NavigationItems aren't managed in the normal Pages admin area
      # If this is true, the NavigationItem won't appear in the Pages admin tree
      # def has_special_admin?
      #   false
      # end

      def editable?
        false
      end
      
      def to_s
        title
      end
      
      def protocol
        "http#{:s if ssl?}://"
      end
      
      def render(controller, request)
        if (ssl? ^ request.ssl?) && !Rails.env.development?
          controller.send :redirect_to, "#{protocol}#{request.host}#{request.request_uri}"
        else
          # This is where I'm getting the stack level too deep error: 26 July 2012
          super
        end
      end
            
      def duplicate(attrs = {})
        new_record = yield if block_given?
        new_record ||= self.dup
        new_record.position = new_record.position.to_i + 1
        super { new_record }.tap do |new_item|
          children.each { |child| child.duplicate(parent_id: new_item.id) }
        end
      end
    end
  end
end
