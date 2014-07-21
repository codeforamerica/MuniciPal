namespace :legistar_events_update do
  desc "Update New Legistar Events"
  task :load => :environment do

    url = "http://webapi.legistar.com/v1/mesa/events/"
    uri = URI.parse(url)
     
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
     
    response = http.request(request)

    if response.code == "200"
      result = JSON.parse(response.body)
      result.reverse.each{|record|
        puts record["EventLastModifiedUtc"]
        puts Time.parse(record["EventLastModifiedUtc"]).getutc
        break if Time.parse(record["EventLastModifiedUtc"]).getutc < Event.order(:EventLastModifiedUtc).last.EventLastModifiedUtc
        Event.find_or_create_by_EventId(record["EventId"], 
                                    :EventGuid => record["EventGuid"],
                                    :EventLastModified => record["EventLastModified"],
                                    :EventLastModifiedUtc => record["EventLastModifiedUtc"],
                                    :EventRowVersion => record["EventRowVersion"],
                                    :EventBodyId => record["EventBodyId"],
                                    :EventBodyName => record["EventBodyName"],
                                    :EventDate => record["EventDate"],
                                    :EventTime => record["EventTime"],
                                    :EventVideoStatus => record["EventVideoStatus"],
                                    :EventAgendaStatusId => record["EventAgendaStatusId"],
                                    :EventMinutesStatusId => record["EventMinutesStatusId"],
                                    :EventLocation => record["EventLocation"])
      }

    else
      puts "ERROR!!!"
    end
  end




end
