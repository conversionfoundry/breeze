class Breeze::Content::Mixins::Permalinks::SlugGenerator < Struct.new(:tree_node)

  def allocate
    c1 = taken_slugs.include?(default_slug)
    c2 = tree_node.new_record?
    c3 = tree_node.persisted? && tree_node.slug_changed?
    if c1 && ( c2 || c3 )
      generate(default_slug, *taken_slugs)
    else
      default_slug
    end
  end

  def generate(default_slug, *taken_slugs)
    taken_slugs.each_with_index do |slug, i|
      this_one = '%s-%s' % [default_slug, i+1]
      result ||= this_one unless taken_slugs.include? this_one
    end
    result ||= '%s-%s' % [default_slug, taken_slugs.count + 1] # if it is still not filled
  end
  
private

  def taken_slugs
    Breeze::Content::Item.where(slug: /.*#{default_slug}.*/i, parent_id: tree_node.parent_id).map(&:slug)
  end
  
  def default_slug
    tree_node.slug || tree_node.title.parameterize.gsub(/(^[\-]+|[-]+$)/, "")
  end
end
