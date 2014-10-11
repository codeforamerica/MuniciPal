require 'geokit'

class AddressesController < ApplicationController

  respond_to :html, :json

  def index
    @in_district = false
    @lat = nil, @lng = nil, @address = nil

    # district given
    if not params[:district].blank?

      @in_district = true

      if params[:mayor]
        puts "got a mayor -----------------------------------------"
      end

      if params[:district] == "all"
        puts "mayor or manager!"
        @mayor = true
        @district_id = 0 # 0 means mayor
        #marker_location = [33.42, -111.835]
        @lat = 33.42
        @lng = -111.835
      else
        # find lat/lon at center of polygon
        any_point = CouncilDistrict.point_in_district params[:district]
        @lat = any_point["lat"]
        @lng = any_point["lng"]
      end

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
        @district_id = @district_polygon.id if not @mayor
        if @mayor #or @manager
          @event_items = EventItem.current.with_matters.order('date DESC')
        else
         @event_items = EventItem.current.with_matters.in_district(@district_polygon.id).order('date DESC')
        end

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
                    :district_id       => @mayor ? 0 : @district_polygon.id,
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
