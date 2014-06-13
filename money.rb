EventItem.where(EventItemMatterType: "Resolution").each {|item| 
@money = item.EventItemTitle.match(/\d+[,.]\d+/i)
if @money 
	puts "MONEY:" + @money.to_s
	puts item.EventItemTitle
else
end
};0