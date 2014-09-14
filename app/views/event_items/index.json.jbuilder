json.array! @event_items do |event_item|
	@event_item = event_item
	json.partial! 'event_item'
end