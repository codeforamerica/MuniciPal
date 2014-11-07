class CouncilDistrict < ActiveRecord::Base
  has_many :event_items

  COORD_SYS_REF = 4326;   # The coordinate system that will be used as the reference and is now Latitude and longitude Coord System

  def self.getDistrict lat, lng
    service_url = "https://services2.arcgis.com/1gVyYKfYgW5Nxb1V/ArcGIS/rest/services/MesaCouncilDistricts/FeatureServer"
    service = Geoservice::MapService.new(url: service_url)
    params = {
      geometry: [lng,lat].join(','),
      geometryType: "esriGeometryPoint",
      inSR: 4326,
      spatialRel: "esriSpatialRelIntersects",
      units: "esriSRUnit_Meter",
      returnGeometry: false
    }
    @response = service.query(0, params)
    puts @response["features"]

    if @response["features"].empty?
      @district_number = nil
    else
      @district_number = @response["features"][0]["attributes"]["DISTRICT"]
    end
    return @district_number
  end

end
