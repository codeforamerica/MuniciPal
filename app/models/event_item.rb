class EventItem < ActiveRecord::Base
  self.primary_key = 'source_id'
  belongs_to :council_district
  belongs_to :event
  belongs_to :matter
    validates :event, presence: true
  has_many :attachments, through: :matter, source: :matter_attachments

  scope :current, ->{ joins(:event).where("events.date > ?", 2.weeks.ago) }
  scope :with_matters, ->{ where("matter_id IS NOT NULL") }
  scope :in_district, ->(district){ where("council_district_id = ?", district) }

end
