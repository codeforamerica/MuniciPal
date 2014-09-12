require 'legistar'

namespace :legistar_event_items do
  desc "Load Legistar event items into database"
  task :load => :environment do |t|
    Legistar.initialize()
    Legistar.fetch_nested_collection('EventItems', nil, 'EventItem', EventItem, 'Events', Event)
    t.enhance do
      Rake::Task["legistar_event_items:geocode"].invoke
    end
  end

  desc "Empty legistar event_items table"
  task :drop => :environment do
    EventItem.destroy_all
  end

  desc "Geocode and locate legistar event items"
  task :geocode => :environment do
    compute_event_item_districts()
  end
end

def compute_event_item_districts()
  EventItem.all.each {|ei|
    if ei.title
      #tmp_address = ei.title.match("[,](.*?)(Road|Drive|Avenue)[,]")
      tmp_dstrct = ei.title.match(/\b(District)\b(.*?)[1-6]/i)
      if tmp_dstrct != "" && tmp_dstrct != nil
        ei.update_attribute(:council_district_id,tmp_dstrct[0][-1].to_i)
      end
    end
  }
end