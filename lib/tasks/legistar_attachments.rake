namespace :legistar_attachments do
  desc "Load Legistar attachments into database (by finding from each event_item)"
  task :load => :environment do
    client = "mesa"

    # for each event_item, if it has a matterId, find and fetch any associated attachments.
    EventItem.where('matter_id IS NOT NULL').each() do |item|
      url = "http://webapi.legistar.com/v1/" + client + "/Matters/" + item.matter_id.to_s + "/Attachments"
      puts "Going to fetch: " + url
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if response.code == "200"
        result = JSON.parse(response.body)
        result.each do |r|
          at = Attachment.new(
            :guid => r['MatterAttachmentGuid'],
            :last_modified_utc => r['MatterAttachmentLastModifiedUtc'],
            :row_version => r['MatterAttachmentRowVersion'],
            :name => r['MatterAttachmentName'],
            :hyperlink => r['MatterAttachmentHyperlink'],
            :filename => r['MatterAttachmentFileName'],
            :matter_version => r['MatterAttachmentMatterVersion'],
            :is_hyperlink => r['MatterAttachmentIsHyperlink'],
            :binary => r['MatterAttachmentBinary'],
            ) {|a| a.id = r['MatterAttachmentId'] }
          at.save

            # (:title => "Foo") { |p| p.id = 5 }
            # :id = r['MatterAttachmentId']
            # :guid = r['MatterAttachmentGuid']
            # :last_modified_utc = r['MatterAttachmentLastModifiedUtc']
            # :row_version = r['MatterAttachmentRowVersion']
            # :name = r['MatterAttachmentName']
            # :hyperlink = r['MatterAttachmentHyperlink']
            # :filename = r['MatterAttachmentFileName']
            # :matter_version = r['MatterAttachmentMatterVersion']
            # :is_hyperlink = r['MatterAttachmentIsHyperlink']
            # :binary = r['MatterAttachmentBinary']
            # :save
        end
      else
        puts 'ERROR! Response code: ' + response.code
      end
    end
  end

desc "Empty legistar attachments table"
  task :drop => :environment  do |t, args|
    Attachment.destroy_all
  end

end
