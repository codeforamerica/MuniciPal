class EventItem < ActiveRecord::Base
	belongs_to :council_district
	belongs_to :event
end
