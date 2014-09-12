#get addresses

def compute_event_item_districts()
	EventItem.all.each {|ei|
		if ei.title
			tmp_address = ei.title.match("[,](.*?)(Road|Drive|Avenue)[,]")
			tmp_dstrct = ei.title.match(/\b(District)\b(.*?)[1-6]/i)
			if tmp_dstrct != "" && tmp_dstrct != nil
				ei.update_attribute(:council_district_id,tmp_dstrct[0][-1].to_i)
			end
		end
	}
end

namespace :legistar_event_items_districts do
  desc "geocode and locate legistar event items"
  task :load => :environment do

	compute_event_item_districts()

  end

end
