class Matter < ActiveRecord::Base
  self.primary_key = 'source_id'
  has_many :event_items
  has_many :matter_attachments
end
