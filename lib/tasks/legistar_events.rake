require 'rgeo/shapefile'
require 'shellwords'

require 'Legistar'

namespace :legistar_events do
  desc "Load Legistar events into database from JSON file"
  task :load => :environment do

    # HACK. For testing, we're limiting the date range of events returned.
    filter = "?$filter=EventDate+ge+datetime'2014-09-01'+and+EventDate+lt+datetime'2014-10-01'"

    Legistar.fetch_collection('events', filter, 'Event', Event)

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
