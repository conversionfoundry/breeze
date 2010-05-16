module Breeze
  module Theming
    class Theme
      include Mongoid::Document

      embedded_in :configuration, :class_name => "Breeze::Configuration", :inverse_of => :themes
      
      field :name
      field :enabled, :type => Boolean, :default => false
      field :position, :type => Integer, :default => -1
      
      validates :name, :presence => true, :format => /\A[a-z][a-z0-9_]*\z/

      after_create :validate_folder_structure

      alias_method :to_s, :name
      def to_sym; name.to_sym; end
      def to_param; name; end

      def path
        File.join self.class.theme_dir, name.to_s
      end
      
      def view_path
        File.join path, "views"
      end
      
      def enable!(bool = true)
        update_attributes :enabled => bool
      end
      
      def disable!
        enable! false
      end
      
      def installed?
        File.exists? path
      end
      
      def <=>(other)
        case position <=> other.position
        when -1 then position == -1 ? 1 : -1
        when  1 then other.position == -1 ? -1 : 1
        when  0 then name <=> other.name
        end
      end
      
      def self.installed
        @installed ||= (configured + unconfigured).sort
      end
      
      def self.[](name)
        installed.detect { |t| t.name == name }
      end
      
      def self.enabled
        installed.select &:enabled?
      end
      
      def self.configured
        @configured ||= Breeze.config.themes.reject { |t| !t.installed? }
      end
      
      def self.unconfigured
        @unconfigured ||= (themes_available - configured.map(&:name)).map do |name|
          Breeze.themes.build :name => name
        end
      end
      
      def view_paths
        enabled.map &:view_path
      end
      
    protected
      def validate_folder_structure
        FileUtils.mkdir_p view_path
      end
    
      def self.theme_dir
        File.join Rails.root, "vendor/themes"
      end
      
      def self.themes_available
        @themes_available ||= Dir[theme_dir + "/*"].map { |d| File.basename(d) }
      end
    end
  end
end