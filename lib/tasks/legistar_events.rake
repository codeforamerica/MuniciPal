require 'rgeo/shapefile'
require 'shellwords'

namespace :legistar_events do
  desc "Load Legistar events into database from JSON file"
  task :load => :environment do

    eventfile = "#{Rails.root}/lib/assets/Mesa/events.json"
    jsond = File.read(eventfile)
    obj = JSON.parse(jsond)
      obj.each{|record|
        Event.create(:EventId => record["EventId"],
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

  desc "Load Legistar events into database from SQL file"
  task :load_sql do
    source = "#{Rails.root}/lib/assets/Mesa/legistar_import.sql"
    sh "psql zone_development < #{Shellwords.escape(source)}" # hack -- need to get db, user, pw from env
  end

desc "Empty legistar events table"  
  task :drop => :environment  do |t, args|
    Event.destroy_all
  end

end
