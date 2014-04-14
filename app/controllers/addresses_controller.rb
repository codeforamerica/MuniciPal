require 'geokit'

class AddressesController < ApplicationController

    respond_to :html, :json

    def index

      @in_district = false


      if params[:address] != nil and !params[:address].empty?
        address = Geokit::Geocoders::MultiGeocoder.geocode params[:address]
        @in_hist_district = HistoricDistrict.inDistrict? address.lat, address.lng
        @in_cosa_district = CosaCouncilDistrict.inDistrict? address.lat, address.lng
        @lat = address.lat
        @lng = address.lng
        @addr = address.full_address
        @hist_district_polygon = HistoricDistrict.getDistrict address.lat, address.lng
        @cosa_district_polygon = CosaCouncilDistrict.getDistrict address.lat, address.lng
      end

      if params[:lat] != nil  and params[:long] != nil and !params[:lat].empty? and !params[:long].empty?
        address = Geokit::Geocoders::MultiGeocoder.reverse_geocode "#{params[:lat]}, #{params[:long]}"
        @in_hist_district = HistoricDistrict.inDistrict? params[:lat], params[:long]
        @in_cosa_district = CosaCouncilDistrict.inDistrict? params[:lat], params[:long]
        @lat = params[:lat]
        @lng = params[:long]
        @addr = address.full_address
        @hist_district_polygon = HistoricDistrict.getDistrict params[:lat], params[:long]
        @cosa_district_polygon = CosaCouncilDistrict.getDistrict params[:lat], params[:long]
      end

      @response = { :lat                    => @lat,
                    :lng                    => @lng,
                    :address                => @addr,
                    :in_hist_district       => @in_hist_district,
                    :hist_district_polygon  => @hist_district_polygon,
                    :in_cosa_district       => @in_cosa_district,
                    :cosa_district_polygon  => @cosa_district_polygon
                  }
      respond_with(@response)
    end
end
