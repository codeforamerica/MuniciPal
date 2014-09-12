require 'legistar'

namespace :legistar_event_items do
  desc "Load Legistar event items into database"
  task :load => :environment do
    Legistar.initialize()
    Legistar.fetch_nested_collection('EventItems', nil, 'EventItem', EventItem, 'Events', Event)
  end

  desc "Empty legistar s table"
  task :drop => :environment  do |t, args|
    EventItem.destroy_all
  end
end
