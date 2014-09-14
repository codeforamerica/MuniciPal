json.extract! @event_item, *(@event_item.attribute_names.map(&:to_sym))
json.attachments @event_item.attachments