require 'rgeo/shapefile'
require 'shellwords'

require 'Legistar'

require 'net/http'
require 'json'
require 'logger'
require 'faraday'
require 'faraday_middleware'
require 'logger'
require 'prettyprint'


namespace :legistar_events do
  desc "Load Legistar events into database from JSON file"
  task :load => :environment do

    Log = Logger.new(STDOUT)
    FileLog = Logger.new('fetch-events.log')
    url = nil

    connection = Faraday.new(url: 'http://webapi.legistar.com') do |conn|
      conn.headers['Accept'] = 'text/json'
      conn.request :instrumentation
      conn.response :json
      conn.adapter Faraday.default_adapter
      url = conn.url_prefix.to_s
    end

    begin
      # HACK. For testing, we're limiting the date range of events returned.
      filter = "?$filter=EventDate+ge+datetime'2014-09-01'+and+EventDate+lt+datetime'2014-10-01'"
      url_path = "/v1/#{Legistar.city}/Events#{filter}"

      response = connection.get(url_path)
      url = url + url_path
      status = response.status

      raise unless status == 200

      events = response.body

      events.each do |item|
        attrs = Legistar.rubify_name(item, 'Event')
        attrs['source_id'] = attrs.delete('id')
        PP.pp(attrs)
        Log.info("Attempting creation of Event with attrs: #{attrs}")
        Event.create(attrs)
      end

      sleep 1
    rescue => e
      msg = "Failed fetching #{url}, status: #{status}"
      Log.error(msg)
      FileLog.error(msg)
      Log.error(e)
      FileLog.error(e)
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
