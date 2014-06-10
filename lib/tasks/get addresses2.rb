#get addresses

def get_license_addr()
	address_strings = []
	EventItem.all.each {|ei|
		if ei.EventItemTitle
		tmp_string = ei.EventItemTitle.match(/\b(District)\b(.*?)[)]/i)
			if tmp_string != nil
				address_strings << {ei.EventItemId=>tmp_string[0]}
			else
			end
		else
		end
	}
	return address_strings
end

addresses = get_license_addr()
puts addresses

