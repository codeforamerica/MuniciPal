EventItem.where(EventItemMatterType: "Contracts").each {|item| 
 @acres = item.EventItemTitle.match(/acres/i)
 if @acres 
 	puts "acres:" + @acres.to_s
 	puts item.EventItemTitle
 else
 end
};0