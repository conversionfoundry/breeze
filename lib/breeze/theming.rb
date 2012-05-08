module Breeze
  module Theming
    def Breeze.themes
      config.themes
    end
    
    Breeze::Configuration.class_eval do
      embeds_many :themes, :class_name => "Breeze::Theming::Theme" do
        def enabled
          @target.select(&:enabled?).sort
        end
        
        def enable!(name, enabled = true)
          theme = @target.detect { |t| t.name == name } || create(:name => name)
          theme.tap do |t|
            t.enable!(enabled)
          end
        end

        def disable!(name); enable!(name, false); end
      end
    end
  end
end
