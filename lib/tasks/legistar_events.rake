require 'rgeo/shapefile'

namespace :legistar_events do
  desc "Load Legistar events into database"
  task :load => :environment do

    eventfile = "#{Rails.root}/lib/assets/Mesa/events.json"
    jsond = File.read(eventfile)
    obj = JSON.parse(jsond)
      obj.each{|record|
        Event.create(:id => record["EventId"],
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
  end

desc "Empty legistar events table"  
  task :drop => :environment  do |t, args|
    Event.destroy_all
  end

end
