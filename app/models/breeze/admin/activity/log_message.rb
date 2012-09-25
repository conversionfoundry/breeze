module Breeze
  module Admin
    module Activity
      class LogMessage
        include Mongoid::Document
        include Mongoid::Timestamps
        identity :type => String
        
        belongs_to_related :user, :class_name => "Breeze::Admin::User"
        field :verb
        embeds_many :objects, :class_name => "Breeze::Admin::Activity::ObjectReference" do
          def <<(objects)
            Array(objects).each do |object|
              build(:class_name => object.class.name, :oid => object.id, :str => object.to_s).to_s unless any? { |o| o.oid == object.id }
            end
          end
          
          def merge!(object_references)
            object_references.each do |object|
              build(object.attributes).to_s unless any? { |o| o.oid == object.oid }
            end
          end
        end
        field :options, :type => Hash
        field :text
        field :html
        
        before_save :cache_text
        
        def self.per_page; 20; end
        
        def verb
          read_attribute(:verb).to_s
        end
        
        def ===(another)
          return false if another.nil?
          user_id == another.user_id and
          verb == another.verb and
          (objects.empty? || another.objects.empty? || objects.first.base_class == another.objects.first.base_class) and
          (created_at || Time.now) < another.created_at + 24.hours
        end
        
        def to_s;    self.text ||= as_text; end
        def to_html; self.html ||= as_html; end
        def kind; base_class.name.demodulize.underscore.to_sym; end
        
      protected
        def past_tense
          options[:past_tense] || verb.sub(/e?$/, "ed")
        end
        
        def base_class
          objects.empty? ? Breeze::Content::Item : objects.first.base_class
        end
        
        def cache_text
          self.text = as_text
          self.html = as_html
        end
        
        def as_text
          to_sentence objects.map(&:to_s)
        end
        
        def as_html
          to_sentence objects.map { |o| o.linked(:verb == :delete) }
        end
        
        def to_sentence(objects)
          if user_id
            "#{user} #{past_tense} #{objects.to_sentence}"
          else
            "#{objects.to_sentence} #{objects.length > 1 ? "were" : "was"} #{past_tense}"
          end
        end
      end
    end
  end
end