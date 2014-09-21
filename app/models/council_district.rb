class CouncilDistrict < ActiveRecord::Base
  has_many :event_items

  COORD_SYS_REF = 4326;   # The coordinate system that will be used as the reference and is now Latitude and Longitude Coord System

  def self.inDistrict? lat, long

    # figure out if it is in a specific area in
    @spec_area = CouncilDistrict.where(
      "ST_Contains(geom, ST_SetSRID(ST_MakePoint(?, ?),#{COORD_SYS_REF}))",
      long, lat)

    return @spec_area.exists?
  end

  def self.getDistrict lat, long
    # figure out if it is in a specific area in historical district
    @area_in_geojson = CouncilDistrict.find_by_sql(
      "select id, name, twit_name, twit_wdgt, ST_AsGeoJSON(geom) as geom
        from council_districts
        where ST_Contains(
              geom,
              ST_SetSRID(ST_MakePoint(#{long}, #{lat}),#{COORD_SYS_REF}))")
    return @area_in_geojson.first
  end

  def self.getDistricts
    # The user might want to map all the districts, so send 'em all.
    @districts_as_geojson = CouncilDistrict.find_by_sql(
      "select id, name, twit_name, twit_wdgt, ST_AsGeoJSON(geom) as geom
        from council_districts");
    return @districts_as_geojson;
  end

  def self.point_in_district district
    @point = ActiveRecord::Base.connection.select_one(
      "WITH results as (
        SELECT ST_PointOnSurface(geom) as point from council_districts where id = #{district}
      ) SELECT ST_X(point) as lng, ST_Y(point) as lat from results"
    )
    @point = @point.merge(@point) { |k,v| v.to_f } #string to float on all hash values
    return @point
  end


end
