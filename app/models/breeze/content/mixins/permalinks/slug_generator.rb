class Breeze::Content::Mixins::Permalinks::SlugGenerator < Struct.new(:tree_node)

  def allocate
    default_slug = tree_node.slug || tree_node.title.parameterize.gsub(/(^[\-]+|[-]+$)/, "")
    taken_slugs = Breeze::Content::Item.where(slug: /.*#{default_slug}.*/i, parent_id: tree_node.parent_id).map(&:slug)
    if taken_slugs.any? && taken_slugs.include?(default_slug) && ( tree_node.new_record? || (tree_node.persisted? && tree_node.slug_changed?) )
      generate(default_slug, *taken_slugs)
    else
      default_slug
    end
  end

  def generate(default_slug, *taken_slugs)
    result = nil
    taken_slugs.each_with_index do |slug, i|
      this_one = '%s-%s' % [default_slug, i+2]
      result ||= this_one unless taken_slugs.include? this_one
    end
    result ||= '%s-%s' % [default_slug, taken_slugs.count + 2] # if it is still not filled
  end
end
