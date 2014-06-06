#get addresses

def get_license_addr()
	address_strings = []
	EventItem.all.each {|ei|
		if ei.EventItemTitle 
			tmp_address = ei.EventItemTitle.match("([,](.*?)(Road|Drive|Avenue)[,]")
			tmp_dstrct = ei.EventItemTitle.match(District)(.*?)[)])[-2].to_i 
				if tmp_dstrct
					ei.district_id = tmp_dstrct
				elsif tmp_address
					ei.address = Geokit::Geocoders::MultiGeocoder.geocode tmp_address
				end
		else
		end
	}
	return address_strings
end

addresses = get_license_addr()
puts addresses

