class CouncilDistrict < ActiveRecord::Base
  self.primary_key = 'id'
  # self.table_name = 'council_districts'
  has_many :event_items

  COORD_SYS_REF = 4326;   # The coordinate system that will be used as the reference and is now Latitude and Longitude Coord System
  COORD_SYS_AREA = 2278;  # The coordinate system used in the data Texas South Central Coordinate System
  COORD_SYS_ZONE = 0;     # The coordinate system used in the actual data but somehow it was wiped to 0, so put it back into the same one to check

  def self.inDistrict? lat, long
    # figure out if it is in a specific area in 
    @spec_area = CouncilDistrict.where("ST_Contains(geom, ST_SetSRID(ST_Transform(ST_SetSRID(ST_MakePoint(?, ?), ?), ?), ?))",
                                              long,
                                              lat,
                                              COORD_SYS_REF,
                                              COORD_SYS_AREA,
                                              COORD_SYS_ZONE)

    return @spec_area.exists?
  end
 
  def self.getDistrict lat, long
    # figure out if it is in a specific area in historical district
    @area_in_geojson = CouncilDistrict.find_by_sql("select id, name, twit_name, twit_wdgt, ST_AsGeoJSON(ST_Transform(ST_SetSRID(geom, #{COORD_SYS_AREA}), #{COORD_SYS_REF}))
                                                        from council_districts 
                                                        where ST_Contains(geom,
                                                        ST_SetSRID(ST_Transform(ST_SetSRID(ST_MakePoint(#{long}, #{lat}),#{COORD_SYS_REF}), #{COORD_SYS_AREA}), #{COORD_SYS_ZONE}))")

    
    return @area_in_geojson.first
  end

end