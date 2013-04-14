namespace :stats do
  desc "count the number of pages"
  task :count_pages => :environment do
    p Breeze::Content::Page.count
  end
end
