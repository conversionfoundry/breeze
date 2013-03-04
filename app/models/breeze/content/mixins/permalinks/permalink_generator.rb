class Breeze::Content::Mixins::Permalinks::PermalinkGenerator < Struct.new(:tree_node)

  def allocate
    tree_node.root? ? "/" : generate
  end

  def generate
    "".tap do |permalink|
      permalink.prepend("/#{tree_node.slug}")
      unless tree_node.parent.try(:root?)
        permalink.prepend(self.class.new(tree_node.parent).generate)    
      end
    end
  end

private

  def permalink_taken?(permalink)
    Breeze::Content::Page.where(permalink: permalink).exists?
  end

end
