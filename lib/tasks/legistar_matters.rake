require "net/http"
require "uri"

namespace :legistar_matters do
  desc "Load Legistar matters into database from REST API"
  task :load => :environment do

    url = "http://webapi.legistar.com/v1/mesa/matters/"
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    if response.code == "200"
      result = JSON.parse(response.body)
      result.each do |record|
        puts record
=begin
        granicusnames = ["MatterId", "MatterGuid", "MatterLastModifiedUtc", "MatterRowVersion", "MatterFile", "MatterName", "MatterTitle", "MatterTypeId", "MatterTypeName", "MatterStatusId", "MatterStatusName", "MatterBodyId", "MatterBodyName", "MatterIntroDate", "MatterAgendaDate", "MatterPassedDate", "MatterEnactmentDate", "MatterEnactmentNumber", "MatterRequester", "MatterNotes", "MatterVersion", "MatterText1", "MatterText2", "MatterText3", "MatterText4", "MatterText5", "MatterDate1", "MatterDate2"]
        createstring = ""
        granicusnames.each{|name|
          createstring << ":" + name.downcase + '=> record["' + name + '"],'
        }
        puts createstring
=end
        Matter.create(
          :matterid=> record["MatterId"],
          :matterguid=> record["MatterGuid"],
          :matterlastmodifiedutc=> record["MatterLastModifiedUtc"],
          :matterrowversion=> record["MatterRowVersion"],
          :matterfile=> record["MatterFile"],
          :mattername=> record["MatterName"],
          :mattertitle=> record["MatterTitle"],
          :mattertypeid=> record["MatterTypeId"],
          :mattertypename=> record["MatterTypeName"],
          :matterstatusid=> record["MatterStatusId"],
          :matterstatusname=> record["MatterStatusName"],
          :matterbodyid=> record["MatterBodyId"],
          :matterbodyname=> record["MatterBodyName"],
          :matterintrodate=> record["MatterIntroDate"],
          :matteragendadate=> record["MatterAgendaDate"],
          :matterpasseddate=> record["MatterPassedDate"],
          :matterenactmentdate=> record["MatterEnactmentDate"],
          :matterenactmentnumber=> record["MatterEnactmentNumber"],
          :matterrequester=> record["MatterRequester"],
          :matternotes=> record["MatterNotes"],
          :matterversion=> record["MatterVersion"],
          :mattertext1=> record["MatterText1"],
          :mattertext2=> record["MatterText2"],
          :mattertext3=> record["MatterText3"],
          :mattertext4=> record["MatterText4"],
          :mattertext5=> record["MatterText5"],
          :matterdate1=> record["MatterDate1"],
          :matterdate2=> record["MatterDate2"])
#        puts "added a matter"
      end
    else
      puts "ERROR!!!"
    end

  end

  desc "Load Legistar matters into database from SQL file"
  task :load_sql do
    source = "#{Rails.root}/lib/assets/Mesa/legistar_import.sql"
    sh "psql zone_development < #{Shellwords.escape(source)}" # hack -- need to get db, user, pw from env
  end

desc "Empty Legistar Matter table"
  task :drop => :environment  do |t, args|
    Matter.destroy_all
  end

end
