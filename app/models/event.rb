class Event < ActiveRecord::Base
  self.primary_key = 'EventId'
  has_many :event_items, dependent: :destroy
end