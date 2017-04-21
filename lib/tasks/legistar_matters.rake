require 'legistar'

namespace :legistar_matters do
  desc "Load Legistar matters into database from REST API"
  task :load => :environment do
    # Limit the date range of data returned since we need only show things near to now.
    filter = "?$filter=MatterIntroDate+ge+datetime'"+(Date.today - 120).to_s+"'+and+MatterIntroDate+lt+datetime'"+(Date.today + 120).to_s+"'"
    Legistar.initialize()
    Legistar.fetch_collection('Matters', filter, 'Matter', Matter)
  end

  desc "Display structure of REST endpoint"
  task :structure => :environment do
    Legistar.fetch_structure('http://webapi.legistar.com/Help/Api/GET-v1-Client-Matters', 'Matter')
  end

  desc "Load Legistar matters into database from SQL file"
  task :load_sql do
    config   = Rails.configuration.database_configuration
    database = config[Rails.env]["database"]
    # username = config[Rails.env]["username"]
    # password = config[Rails.env]["password"]
    source = "#{Rails.root}/lib/assets/Mesa/legistar_import.sql"
    sh "psql #{database} < #{Shellwords.escape(source)}"
  end

desc "Empty Legistar Matter table"
  task :drop => :environment  do |t, args|
    Matter.destroy_all
  end

end
