require 'rgeo/shapefile'
require 'shellwords'

namespace :legistar_events do
  desc "Load Legistar events into database from JSON file"
  task :load => :environment do

    url = "http://webapi.legistar.com/v1/mesa/events/"
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    if response.code == "200"
      result = JSON.parse(response.body)
      result.each{|record|
        Event.create(:id => record["EventId"],
                    :guid => record["EventGuid"],
                    :last_modified => record["EventLastModified"], #undocumented api field?
                    :last_modified_utc => record["EventLastModifiedUtc"],
                    :row_version => record["EventRowVersion"],
                    :body_id => record["EventBodyId"],
                    :body_name => record["EventBodyName"],
                    :date => record["EventDate"],
                    :time => record["EventTime"],
                    :video_status => record["EventVideoStatus"],
                    :agenda_status_id => record["EventAgendaStatusId"],
                    :minutes_status_id => record["EventMinutesStatusId"],
                    :location => record["EventLocation"])
      }

    else
      puts "ERROR!!!"
    end
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
