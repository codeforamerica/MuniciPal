json.extract! @matter, *(@matter.attribute_names.map(&:to_sym))
json.event_items @matter.event_items