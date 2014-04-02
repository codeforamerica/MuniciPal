#require 'cgi'
require 'geokit'

class AddressesController < ApplicationController

    def index

      @in_district = false


      if params[:address] != nil and !params[:address].empty?
        address = Geokit::Geocoders::MultiGeocoder.geocode(params[:address])
        @in_district = HistoricDistrict.inDistrict? address.lat, address.lng
        @lat = address.lat
        @lng = address.lng
      end
      if params[:lat] != nil  and params[:long] != nil and !params[:lat].empty? and !params[:long].empty?
        @in_district = HistoricDistrict.inDistrict? params[:lat], params[:long]
        @lat = params[:lat]
        @lng = params[:long]
      end

    end
end

#ENDPOINT = 'http://api.wunderground.com/api/%s/conditions/q/%s/%s.json' % [API_KEY,STATE,CITY]
# include Geokit::Geocoders
# res=MultiGeocoder.geocode('100 Spear st, San Francisco, CA')
# puts res.ll # ll=latitude,longitude

#       if params[:lat] == nil or params[:long] == nil or params[:lat].empty? or params[:long].empty?
#         @addr_url_string = CGI::escape(params[:address])

#long=-98.491842&lat=29.414678
#http://0.0.0.0:3000/?address=302%20madison%20street,%20san%20antonio,%20tx
#http://0.0.0.0:3000/?long=-98.491842&lat=29.414678