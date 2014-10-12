class Event < ActiveRecord::Base
  self.primary_key = 'source_id'
  has_many :event_items, dependent: :destroy

  # scope :current, ->{ where("date > ?", 4.months.ago) }

end

