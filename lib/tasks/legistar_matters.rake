require "net/http"
require "uri"

namespace :legistar_matters do
  desc "Load Legistar matters into database from REST API"
  task :load => :environment do
    # DEBUG: filter items returned for quicker development cycles
    filter = "?$filter=MatterIntroDate+ge+datetime'2014-09-05'+and+MatterIntroDate+lt+datetime'2014-10-01'"
    Legistar.initialize()
    Legistar.fetch_collection('Matters', filter, 'Matter', Matter)
  end

  desc "Display structure of REST endpoint"
  task :structure => :environment do
    Legistar.initialize()
    Legistar.fetch_structure('http://webapi.legistar.com/Help/Api/GET-v1-Client-Matters', 'Matter')
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
