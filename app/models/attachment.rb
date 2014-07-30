class Attachment < ActiveRecord::Base
    belongs_to :matter
    validates :matter, presence: true
end
