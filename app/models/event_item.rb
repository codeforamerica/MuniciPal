class EventItem < ActiveRecord::Base
  self.primary_key = 'source_id'
  belongs_to :council_district
  belongs_to :event
  belongs_to :matter
    validates :event, presence: true
  has_many :attachments, through: :matter, source: :matter_attachments
end
