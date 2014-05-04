require 'spec_helper'
require 'rake'

describe HistoricDistrict do

  before do
    Zone::Application.load_tasks
    Rake::Task['historic_districts:load'].invoke 
  end

  it "returns true if latitude and longitude is in any Historic district" do 
    # Lat Long of 302 Madison St, San Antonio
    HistoricDistrict.inDistrict?(29.414432, -98.491916).should be_true
  end

  it "returns false if latitude and longitude is not in any Historic district" do
    # Lat Long of 155 9th St, San Francisco
    HistoricDistrict.inDistrict?(37.775518,-122.413821).should be_false
  end

  it "returns info and geojson of a specific district if latitude and longitude is in a Historic district" do
    district = HistoricDistrict.getDistrict(29.414432, -98.491916)
    # name, acres, shape_leng, shape_area, ST_AsGeoJSON
    district.name.should == "King William"
  end

  it "returns null if latitude and longitude is not in a Historic district" do
    # Lat Long of 155 9th St, San Francisco
    HistoricDistrict.getDistrict(37.775518,-122.413821).should be_nil

  end

  after do
    Rake::Task['historic_districts:drop'].invoke 
  end
end
