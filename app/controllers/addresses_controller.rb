require 'geokit'

class AddressesController < ApplicationController

    respond_to :html, :json

    def index

      @in_district = false


      if params[:address] != nil and !params[:address].empty?
        address = Geokit::Geocoders::MultiGeocoder.geocode params[:address]
        @in_district = CouncilDistrict.inDistrict? address.lat, address.lng
        @lat = address.lat
        @lng = address.lng
        @addr = address.full_address
        @district_polygon = CouncilDistrict.getDistrict address.lat, address.lng
      end

      if params[:lat] != nil  and params[:long] != nil and !params[:lat].empty? and !params[:long].empty?
        address = Geokit::Geocoders::MultiGeocoder.reverse_geocode "#{params[:lat]}, #{params[:long]}"
        @in_district = CouncilDistrict.inDistrict? params[:lat], params[:long]
        @lat = params[:lat]
        @lng = params[:long]
        @addr = address.full_address
        @district_polygon = CouncilDistrict.getDistrict params[:lat], params[:long]
      end

      @response = { :lat                    => @lat,
                    :lng                    => @lng,
                    :address                => @addr,
                    :in_district       => @in_district,
                    :district_polygon  => @district_polygon
                  }
      respond_with(@response)
    end
end
