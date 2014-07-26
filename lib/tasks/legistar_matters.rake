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
        Matter.create(
          :MatterId=> record["MatterId"],
          :guid=> record["guid"],
          :last_modified_utc=> record["MatterLastModifiedUtc"],
          :row_version=> record["MatterRowVersion"],
          :file=> record["MatterFile"],
          :name=> record["MatterName"],
          :title=> record["MatterTitle"],
          :type_id=> record["MatterTypeId"],
          :type_name=> record["MatterTypeName"],
          :status_id=> record["MatterStatusId"],
          :status_name=> record["MatterStatusName"],
          :body_id=> record["MatterBodyId"],
          :body_name=> record["MatterBodyName"],
          :intro_date=> record["MatterIntroDate"],
          :agenda_date=> record["MatterAgendaDate"],
          :passed_date=> record["MatterPassedDate"],
          :enactment_date=> record["MatterEnactmentDate"],
          :enactment_number=> record["MatterEnactmentNumber"],
          :requester=> record["MatterRequester"],
          :notes=> record["MatterNotes"],
          :version=> record["MatterVersion"],
          :text1=> record["MatterText1"],
          :text2=> record["MatterText2"],
          :text3=> record["MatterText3"],
          :text4=> record["MatterText4"],
          :text5=> record["MatterText5"],
          :date1=> record["MatterDate1"],
          :date2=> record["MatterDate2"])
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
