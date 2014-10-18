require 'legistar'

namespace :legistar_events do
  desc "Load Legistar events into database from JSON file"
  task :load => :environment do

    # HACK. For testing, we're limiting the date range of events returned.
    filter = "?$filter=EventDate+ge+datetime'"+(Date.today - 90).to_s+"'+and+EventDate+lt+datetime'"+Date.today.to_s+"'"
    Legistar.initialize()
    Legistar.fetch_collection('events', filter, 'Event', Event)

  end

  desc "Load Legistar events into database from SQL file"
  task :load_sql do
    config   = Rails.configuration.database_configuration
    database = config[Rails.env]["database"]
    # username = config[Rails.env]["username"]
    # password = config[Rails.env]["password"]
    source = "#{Rails.root}/lib/assets/Mesa/legistar_import.sql"
    sh "psql #{database} < #{Shellwords.escape(source)}"
  end

  desc "Empty legistar events table"
  task :drop => :environment  do |t, args|
    Event.destroy_all
  end

end
