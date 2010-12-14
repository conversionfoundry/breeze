module Breeze
  module Content
    class Redirect < Item
      field :permalink
      field :target
      field :kind, :type => Integer, :default => 301
      
      KINDS = {
        301 => "Moved Permanently",
        302 => "Moved"
      }.freeze unless defined?(KINDS)
      
      validates_presence_of :permalink, :target
      validates_uniqueness_of :permalink
      validates_format_of :permalink, :with => /^\//, :message => "must start with a slash", :if => :permalink?
      validates_format_of :target, :with => /^\//, :message => "must start with a slash", :if => :target?
      before_validation :check_leading_slashes
      validates_inclusion_of :kind, :in => KINDS.keys
      
      def render(controller, request)
        controller.redirect_to target, :status => kind
        controller.performed?
      end
      
      def <=>(another)
        permalink <=> another.permalink
      end
      
    protected
      def check_leading_slashes
        self.permalink = "/#{permalink}" unless permalink.blank? || permalink.starts_with?("/")
        self.target = "/#{target}" unless target.blank? || target.starts_with?("/")
      end
        
    end
  end
end