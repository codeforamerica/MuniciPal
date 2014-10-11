require 'geokit'

class AddressesController < ApplicationController

  respond_to :html, :json

  def index
    @in_district = false
    @lat = nil, @lng = nil, @address = nil

    # district given
    if not params[:district].blank?

      # find lat/lon at center of polygon
      @in_district = true
      any_point = CouncilDistrict.point_in_district params[:district]
      @lat = any_point["lat"]
      @lng = any_point["lng"]

      # find address at given lat/lon
      @address = Geokit::Geocoders::MultiGeocoder.reverse_geocode "#{@lat}, #{@lng}"
    end

    # address given; geocode to get lat/lon
    if not params[:address].blank?
      @address = Geokit::Geocoders::MultiGeocoder.geocode params[:address]
      @in_district = CouncilDistrict.inDistrict? @address.lat, @address.lng
      @lat = @address.lat
      @lng = @address.lng
      puts "LAT/LON from address: " + @lat.to_s + "/" + @lng.to_s
    end

    # lat/lon given, reverse geocode to find address
    if not params[:lat].blank? and not params[:long].blank?
      @address = Geokit::Geocoders::MultiGeocoder.reverse_geocode "#{params[:lat]}, #{params[:long]}"
      @in_district = CouncilDistrict.inDistrict? params[:lat], params[:long]
      @lat = params[:lat]
      @lng = params[:long]
      puts "LAT/LON from params: " + @lat.to_s + "/" + @lon.to_s
    end

    if @address
      @addr = @address.full_address
      @district_polygon = CouncilDistrict.getDistrict @lat, @lng
      if @district_polygon and @district_polygon.id
        @event_items = EventItem.current.with_matters.in_district(@district_polygon.id).order('date DESC')


        attachments = @event_items.map(&:attachments) #see http://ablogaboutcode.com/2012/01/04/the-ampersand-operator-in-ruby/
        events = @event_items.map(&:event).uniq #see http://ablogaboutcode.com/2012/01/04/the-ampersand-operator-in-ruby/
      else
        puts "ERROR: Whaaaaaat?! No district/id. You ran rake council_districts:load to populate the table right?"
      end
    end

    # only build a response if user asks for something specific
    if (['district', 'mayor', 'address', 'lat', 'lon'] & params.keys).length > 0
      @response = { :lat                    => @lat,
                    :lng                    => @lng,
                    :address                => @addr,
                    :in_district       => @in_district,
                    :district_id       => @mayor ? 0 : @district_id,
                    :district_polygon  => @district_polygon,
                    :event_items       => @event_items,
                    :attachments => attachments,
                    :events => events
                  }
    else
      @response = {}
    end

    @districts = CouncilDistrict.getDistricts()
    respond_with(@response)
  end
end