require 'geokit'

class AddressesController < ApplicationController

  respond_to :html, :json

  def index
    @in_district = false
    @lat = nil, @lng = nil, @address = nil

    if params[:address] != nil and !params[:address].empty?
      @address = Geokit::Geocoders::MultiGeocoder.geocode params[:address]
      @in_district = CouncilDistrict.inDistrict? @address.lat, @address.lng
      @lat = @address.lat
      @lng = @address.lng
    end

    if params[:lat] != nil  and params[:long] != nil and !params[:lat].empty? and !params[:long].empty?
      @address = Geokit::Geocoders::MultiGeocoder.reverse_geocode "#{params[:lat]}, #{params[:long]}"
      @in_district = CouncilDistrict.inDistrict? params[:lat], params[:long]
      @lat = params[:lat]
      @lng = params[:long]
    end

    if @address != nil 
      @addr = @address.full_address
      @district_polygon = CouncilDistrict.getDistrict @lat, @lng 
      @event_items = CouncilDistrict.find(@district_polygon.id).event_items.limit(10)
    end
    
    @response = { :lat                    => @lat,
                  :lng                    => @lng,
                  :address                => @addr,
                  :in_district       => @in_district,
                  :district_polygon  => @district_polygon,
                  :event_items       => @event_items
                }
    respond_with(@response)
  end
end
