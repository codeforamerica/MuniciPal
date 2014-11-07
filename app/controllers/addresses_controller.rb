require 'geokit'

class AddressesController < ApplicationController

  respond_to :html, :json

  def index
  #index taxes a lat/lng pair, an address, a district, or a person,
  #and returns details about representatives, events, items, and attachments
  #as well as the original data
    @response = { :lat                    => nil,
                  :lng                    => nil,
                  :address                => "",
                  :in_district       => false,
                  :person_title      => "",
                  :district       => nil,
                  :event_items       => nil,
                  :attachments => nil,
                  :events => nil
                }

    #SET THE VALUES IN THE RESPONSE TO THEIR VALUES IN THE PARAMS
    params.each_key{|key| @response[key.to_sym] = params[key.to_sym]}
    #move block below to own route? - seem like params' key should be :title, not :title.value?
    # /people/byTitle/:title (title = mayor, manager, councilmember, all)
    if params[:mayor]
      @response[:person_title] = "mayor"
    elsif params[:manager]
      @response[:person_title] = "manager"
    else
      @response[:person_title] = "councilmember"
    end

    # address given; geocode to get lat/lon
    # /districts/byAddress/:address -> lat,lon

    if @response[:lat] and @response[:lng]
      @userlocation = { lat: @response[:lat], lng: @response[:lng] }
    end

    if not @response[:address].empty?
    #if address is given:
      @geocoded_address = Geokit::Geocoders::MultiGeocoder.geocode @response[:address]
      @response[:lat] = @geocoded_address.lat
      @response[:lng]  = @geocoded_address.lng
      @userlocation = { lat: @response[:lat], lng: @response[:lng] }
    # elsif (not @response[:lat].blank? and not @response[:lng].blank?)
    # #if lat and lng are given or geocoded from address
    #   @location = { lat: @response[:lat], lng: @response[:lng] }
    end

    if @userlocation
      @district_number = CouncilDistrict.getDistrict @response[:lat], @response[:lng] #@lat, @lng
      @response[:in_district] = !@district_data.nil?

      @response[:district] = @district_number
    end

    # if not @response[:district].blank?
    #   #NOT SURE WE NEED THIS LINE BELOW - THE JSON ISN'T USED FOR ANYTHING
    #   @district_json = CouncilDistrict.find(@response[:district])
    #   @response[:in_district] = true
    # end


    if @response[:district]
      @response[:in_district] = true

      if @response[:district] == "all"
        # use lat/lon at center of Mesa
        @response[:lat] = 33.42
        @response[:lng] = -111.835
      elsif @response[:district].to_i.between?(1,6) # Valid districts in Mesa are 1-6 (inclusive)
        @response[:event_items] = EventItem.current.with_matters.in_district(@response[:district]).order('date DESC') +
                     EventItem.current.with_matters.no_district.order('date DESC') if @response[:in_district]
        @response[:lat] = 33.42
        @response[:lng] = -111.835
      end
    end

#    @addr = @geocoded_address.full_address if @geocoded_address

    if @response[:person_title] == "mayor" or @response[:person_title] == "manager"
      @response[:event_items] = EventItem.current.with_matters.order('date DESC') #all
      @response[:district] = nil
        if !@response[:lat] or !@response[:lng]
          @response[:lat] = 33.42
          @response[:lng] = -111.835
          #the following line is a legacy thing from a variable in JS that flags whether a user was in the city
          @response[:in_district] = true;
          # @district_polygon = CouncilDistrict.getDistrict @lat, @lng
          # if @district_polygon and @district_polygon.id
          #   @district_id = @district_id.id
          # end
        end
    end

    if @response[:event_items]
      @response[:attachments] = @response[:event_items].map(&:attachments) #see http://ablogaboutcode.com/2012/01/04/the-ampersand-operator-in-ruby/
      @response[:events] = @response[:event_items].map(&:event).uniq #see http://ablogaboutcode.com/2012/01/04/the-ampersand-operator-in-ruby/
    end

    respond_with(@response)
  end
end
