class MatterAttachment < ActiveRecord::Base
  self.primary_key = 'source_id'
    belongs_to :matter
    validates :matter, presence: true
end
