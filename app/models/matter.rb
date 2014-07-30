class Matter < ActiveRecord::Base
	has_many :event_items
	has_many :attachments
end
