class Event < ActiveRecord::Base
  self.primary_key = 'source_id'
  has_many :event_items, dependent: :destroy
end