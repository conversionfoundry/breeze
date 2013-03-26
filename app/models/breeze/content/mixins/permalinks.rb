module Breeze::Content::Mixins::Permalinks
  extend ActiveSupport::Concern

  included do
    field :permalink
    field :slug

    before_validation :fill_in_slug
    before_validation :regenerate_permalink
    after_save :update_child_permalinks

    validates_format_of :permalink, 
      :with => /^(\/|(\/[\w\-]+)+)$/,
      :message => "must contain only letters, numbers, underscores or dashes"
    validates_uniqueness_of :permalink 
    validates :slug, uniqueness: { scope: :parent_id }
    index({ permalink: 1 }, { unique: true })

    attr_accessible :permalink, :slug
  end

  module ClassMethods
  end

  def canonical_url
    [Breeze.domain, permalink].join
  end

  # When a permalink changes, permalinks for child pages also need to be
  # updated Alban Feb 2013: This is transversal to two concerns, tree structure
  # and permalink Another service object should be responsible of this + Tree
  # structure has a method like apply_from_top_to_bottom where we pass a block
  # to do some stuff, in this case refreshing permalinks
  def update_child_permalinks
    if respond_to?(:children) && permalink_changed?
      children.each do |child|
        child.permalink = PermalinkGenerator.new(child).allocate
        child.save
      end
    end
  end

private

  def fill_in_slug
    self.slug = SlugGenerator.new(self).allocate
  end

  def regenerate_permalink
    self.permalink = PermalinkGenerator.new(self).allocate
  end

end
