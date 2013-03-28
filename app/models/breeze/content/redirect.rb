module Breeze
  module Content
    class Redirect
      include Mongoid::Document
      field :permalink
      field :targetlink
      field :kind, :type => Integer, :default => 301
      
      KINDS = {
        301 => "Moved Permanently",
        302 => "Moved"
      }.freeze unless defined?(KINDS)
      
      validates_presence_of :permalink, :targetlink
      validates_uniqueness_of :permalink
      validates_format_of :permalink, 
        :with => /^\//, 
        :message => "must start with a slash"
      validates_format_of :targetlink, 
        :with => /^\//, 
        :message => "must start with a slash"

      #TODO add an index on the permalink. 

      before_validation :check_leading_slashes
      # missing validation to prevent redirection loops

      validates_inclusion_of :kind, :in => KINDS.keys
      
      def render(controller, request)
        controller.redirect_to targetlink, :status => kind
        controller.performed?
      end
      
      def <=>(another)
        permalink <=> another.permalink
      end
      
    protected
      def check_leading_slashes
        self.permalink = "/#{permalink.sub(/\/$/, "")}" unless permalink.blank? || permalink.starts_with?("/")
        self.targetlink = "/#{targetlink.sub(/\/$/, "")}" unless targetlink.blank? || targetlink.starts_with?("/")
      end
    end
  end
end
