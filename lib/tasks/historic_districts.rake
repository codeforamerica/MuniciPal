require 'rgeo/shapefile'

namespace :historic_districts do
  desc "Load historic district into database"
  task :load => :environment do

    HistoricDistrict.destroy_all
    shpfile = "#{Rails.root}/lib/assets/SHistoricDistricts/HistoricDistricts.shp"
    
    RGeo::Shapefile::Reader.open(shpfile, {:srid => -1}) do |file|
      puts "File contains #{file.num_records} records"
      file.each do |n|
         record = n.attributes
         HistoricDistrict.create( :name => record["NAME"], 
                                  :acres => record["ACRES"], 
                                  :shape_leng => record["Shape_Leng"], 
                                  :shape_area => record["Shape_Area"], 
                                  :geom => n.geometry)
      end
    end
  end

  desc "Empty historic district table"  
  task :drop => :environment  do |t, args|
    HistoricDistrict.destroy_all
  end

end
