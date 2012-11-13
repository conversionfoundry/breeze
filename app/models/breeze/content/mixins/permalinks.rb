module Breeze::Content::Mixins::Permalinks
  def self.included(base)
    base.field :permalink
    base.field :slug

    base.attr_protected :_id

    base.before_validation :fill_in_slug
    base.before_validation :regenerate_permalink
    base.after_save :update_child_permalinks

    base.validates_format_of :permalink, :with => /^(\/|(\/[\w\-]+)+)$/, :message => "must contain only letters, numbers, underscores or dashes"
    base.validates_uniqueness_of :permalink 
    base.validates :slug, uniqueness: { scope: :parent_id }
    base.index({ permalink: 1 }, { unique: true })
    
    base.class_eval do
      def permalink(include_domain = false)
        if include_domain
          "#{Breeze.domain}#{read_attribute(:permalink)}"
        else
          read_attribute(:permalink)
        end
      end
    end
  end
  
  # When a permalink changes, permalinks for child pages also need to be updated
  def update_child_permalinks
    if respond_to?(:children) && permalink_changed?
      children.each do |child|
        child.permalink = PermalinkGenerator.new(child).allocate
        child.save
      end
    end
  end

  def redirects
    Breeze::Content::Redirect.where(:targetlink => permalink)
  end

protected

  def fill_in_slug
    self.slug = SlugGenerator.new(self).allocate
  end

  def regenerate_permalink
    self.permalink = PermalinkGenerator.new(self).allocate
  end

end
