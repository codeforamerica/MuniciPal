require 'uri'
require 'net/http'
require 'json'

def get_event_items(event_id)
	sleep(60)
	uri = URI("http://webapi.legistar.com/v1/mesa/events/"+ event_id.to_s + "/eventitems")
	#params = { <query_hash> }
	headers = { 'ACCEPT'  => 'text/json' }

	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.path)
	#request.set_form_data( params )
	request = Net::HTTP::Get.new( uri.path, headers)
	response = http.request(request)
	return response.body
end

namespace :legistar_event_items do
  desc "Load Legistar event items into database"
  task :load => :environment do

	Event.all.each {|event|
		response = get_event_items(event.EventId)
		json_data = JSON.parse(response)
		json_data.each {|record|
			EventItem.create(:event_id  => event.EventId, 
				:EventItemId => record["EventItemId"],
				:EventItemGuid => record["EventItemGuid"],
				:EventItemLastModified => record["EventItemLastModified"],
				:EventItemLastModifiedUtc => record["EventItemLastModifiedUtc"],
				:EventItemRowVersion => record["EventItemRowVersion"],
				:EventItemEventId => record["EventItemEventId"],
				:EventItemAgendaSequence => record["EventItemAgendaSequence"],
				:EventItemMinutesSequence => record["EventItemMinutesSequence"],
				:EventItemAgendaNumber => record["EventItemAgendaNumber"],
				:EventItemVideo => record["EventItemVideo"],
				:EventItemVideoIndex => record["EventItemVideoIndex"],
				:EventItemVersion => record["EventItemVersion"],
				:EventItemAgendaNote => record["EventItemAgendaNote"],
				:EventItemMinutesNote => record["EventItemMinutesNote"],
				:EventItemActionId => record["EventItemActionId"],
				:EventItemAction => record["EventItemAction"],
				:EventItemActionText => record["EventItemActionText"],
				:EventItemPassedFlag => record["EventItemPassedFlag"],
				:EventItemPassedFlagText => record["EventItemPassedFlagText"],
				:EventItemRollCallFlag => record["EventItemRollCallFlag"],
				:EventItemFlagExtra => record["EventItemFlagExtra"],
				:EventItemTitle => record["EventItemTitle"],
				:EventItemTally => record["EventItemTally"],
				:EventItemConsent => record["EventItemConsent"],
				:EventItemMoverId => record["EventItemMoverId"],
				:EventItemMover => record["EventItemMover"],
				:EventItemSeconderId => record["EventItemSeconderId"],
				:EventItemSeconder => record["EventItemSeconder"],
				:EventItemMatterId => record["EventItemMatterId"],
				:EventItemMatterGuid => record["EventItemMatterGuid"],
				:EventItemMatterFile => record["EventItemMatterFile"],
				:EventItemMatterName => record["EventItemMatterName"],
				:EventItemMatterType => record["EventItemMatterType"],
				:EventItemMatterStatus => record["EventItemMatterStatus"],
			)
		}
	}
  end
end