namespace :legistar_attachments do
  desc "Load Legistar attachments into database (by finding from each event_item)"
  task :load => :environment do
    Legistar.initialize()
    Legistar.fetch_nested_collection('MatterAttachments', nil, 'MatterAttachment', MatterAttachment, 'Matters', Matter)
  end

    # for each event_item, if it has a matterId, find and fetch any associated attachments.
    EventItem.where('matter_id IS NOT NULL').each() do |item|
      url = "http://webapi.legistar.com/v1/" + client + "/Matters/" + item.matter_id.to_s + "/Attachments"
      puts "Going to fetch: " + url
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

    end
  end

desc "Empty legistar attachments table"
  task :drop => :environment  do |t, args|
    Attachment.destroy_all
  end

end
