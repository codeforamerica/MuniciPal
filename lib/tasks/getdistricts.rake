#get addresses

def get_license_addr()
	address_strings = []
	EventItem.all.each {|ei|
		if ei.EventItemTitle
			tmp_address = ei.EventItemTitle.match("[,](.*?)(Road|Drive|Avenue)[,]")
			tmp_dstrct = ei.EventItemTitle.match(/\b(District)\b(.*?)[1-6]/i)
				if tmp_dstrct != "" && tmp_dstrct != nil # & tmp_dstrct[0][-2].to_i != 0
					ei.update_attribute(:council_district_id,tmp_dstrct[0][-1].to_i)
				#	ei.council_district_id = tmp_dstrct[0][-2].to_i
				elsif tmp_address
				#	ei.address = Geokit::Geocoders::MultiGeocoder.geocode tmp_address
				#	eit["address"] = Geokit::Geocoders::MultiGeocoder.geocode tmp_address[0].to_s
				end

		else
		end
	}
	return address_strings
end

namespace :legistar_event_items_districts do
  desc "geocode and locate legistar event items"
  task :load => :environment do

	get_license_addr()

  end

end
