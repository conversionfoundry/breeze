# Breeze::Content::Item.each do |item|
#   clean_item(item)
# end


def find_position(item, placement)
  similar_region_elements = item.placements.where(region: placement.region)
  taken_position  = similar_region_elements.map(&:position).compact
  positions = *(1..similar_region_elements.count)
  (positions - taken_position).first
end

def clean_placement(placement, position)
  placement.update_attribute(:position, position)
end

def clean_item(item)
  item.placements.each do |placement|
    position = find_position(item, placement)
    clean_placement(placement, position)
  end
end

namespace :data do
  desc "set default position for all items having a null position"
  task :clean_position => :environment do
    clean_item(Breeze::Content::Item.first)
  end
end
