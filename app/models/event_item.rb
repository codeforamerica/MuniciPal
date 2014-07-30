class EventItem < ActiveRecord::Base
	belongs_to :council_district
	belongs_to :event
	belongs_to :matter
    validates :event, presence: true
end
