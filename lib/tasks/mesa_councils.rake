require 'rgeo/shapefile'

namespace :mesa_councils do
  desc "Load COSA council district into database"
  task :load => :environment do

    CouncilDistrict.destroy_all
    shpfile = "#{Rails.root}/lib/assets/Mesa/Councils.shp"
    
    RGeo::Shapefile::Reader.open(shpfile, {:srid => -1}) do |file|
      puts "File contains #{file.num_records} records"
      file.each do |n|
         record = n.attributes
         CouncilDistrict.create(:district => record["DISTRICT"], 
                                    :geom => n.geometry)
      end
    end
  end

  desc "Empty COSA council district table"  
  task :drop => :environment  do |t, args|
    CouncilDistrict.destroy_all
  end

end
