class Breeze::Content::Mixins::Permalinks::PermalinkGenerator < Struct.new(:tree_node)

  def allocate
    if tree_node.root? 
      "/"
    else
      generate
    end
  end

  def generate
    "".tap do |permalink|
      permalink.prepend("/#{tree_node.slug}")
      if parent_is_not_root?(tree_node) 
        permalink.prepend(self.class.new(tree_node.parent).generate)    
      end
    end
  end

private

  def permalink_taken?(permalink)
    Breeze::Content::Page.where(permalink: permalink).exists?
  end

  def parent_is_not_root?(tree_node)
    tree_node.parent.present? && 
      !tree_node.parent.root?
  end



end
