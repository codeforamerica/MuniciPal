require 'Legistar'

require 'net/http'
require 'json'
require 'logger'
require 'faraday'
require 'faraday_middleware'
require 'logger'
require 'prettyprint'

namespace :legistar_event_items do
  desc "Load Legistar event items into database"
  task :load => :environment do

    log = Logger.new(STDOUT)
    fileLog = Logger.new('fetch-event-items.log')
    log.level = fileLog.level = Logger::DEBUG

    log.info("peter is saving things")
    fileLog.info("Peter is saving things")


    connection = Faraday.new(url: 'http://webapi.legistar.com') do |conn|
      conn.headers['Accept'] = 'text/json'
      conn.request :instrumentation
      conn.response :json
      conn.adapter Faraday.default_adapter
    end

    Event.all.each do |event|

      begin
        response = connection.get("/v1/#{Legistar.city}/Events/#{event.source_id}/EventItems")
        raise unless response.status == 200
        event_items = response.body

        event_items.each do |item|
          attrs = Legistar.rubify_name(item, 'EventItem')

          attrs['source_id'] = attrs.delete('id')
          #debugger
          PP.pp(attrs)
          log.info("Attempting creation of EventItem with attrs: #{attrs}")

          EventItem.create(attrs)
          #debugger
        end
        sleep 1
      rescue => e
        msg = "Failed fetching Event ID: #{event.id}, url: #{conn.url_prefix.to_s}, status: #{response.status}"
        log.error(msg)
        fileLog.error(msg)
        log.error(e)
        fileLog.error(e)
      end
    end
  end

  desc "Empty legistar s table"
  task :drop => :environment  do |t, args|
    EventItem.destroy_all
  end
end