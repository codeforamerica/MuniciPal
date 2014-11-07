require 'spec_helper'

describe AddressesController do
    before(:all) do 
    @city_council_1 = FactoryGirl.create(:council_district)
    @king_william = FactoryGirl.create(:historic_district)
  end

  describe "GET #index" do

    context "when in district address is passed in" do
      before { get :index, :format => 'json', :address =>"302 Madison St, San Antonio"}

      it { expect(json['lat']).to be_within(0.01).of(29.414432) }
      it { expect(json['lng']).to be_within(0.01).of(-98.491916) }
      it { expect(json['in_hist_district']).to be_true }
      it { expect(json['hist_district_polygon']).not_to be_nil }
      it { expect(json['in_district']).to be_true }
      it { expect(json['district_polygon']).not_to be_nil }

      it { should respond_with 200 }
    end

    context "when out of district address is passed in" do
      before { get :index, :format => 'json', :address =>"155 9th St, San Francisco"}

      it { expect(json['lat']).to be_within(0.01).of(37.775518) }
      it { expect(json['lng']).to be_within(0.01).of(-122.413821) }
      it { expect(json['in_hist_district']).to be_false }
      it { expect(json['hist_district_polygon']).to be_nil }
      it { expect(json['in_district']).to be_false }
      it { expect(json['district_polygon']).to be_nil }

      it { should respond_with 200 }
    end

    context "when in district lat/lng is passed in" do
      before { get :index, :format => 'json', :lat => "29.414432", :lng => "-98.491916" }

      it { expect(json['lat']).to eq("29.414432") }
      it { expect(json['lng']).to eq("-98.491916")}
      # it { expect(json['lat']).to be_within(0.01).of(29.414432) }
      # it { expect(json['lng']).to be_within(0.01).of(-98.491916) }
      it { expect(json['in_hist_district']).to be_true }
      it { expect(json['hist_district_polygon']).not_to be_nil }
      it { expect(json['in_district']).to be_true }
      it { expect(json['district_polygon']).not_to be_nil }

      it { should respond_with 200 }
    end

    context "when out of district lat/lng is passed in" do
      before { get :index, :format => 'json', :lat => "37.775518", :lng => "-122.413821" }

      it { expect(json['lat']).to eq("37.775518") }
      it { expect(json['lng']).to eq("-122.413821")}
      # it { expect(json['lat']).to be_within(0.01).of(37.775518) }
      # it { expect(json['lng']).to be_within(0.01).of(-122.413821) }
      it { expect(json['in_hist_district']).to be_false }
      it { expect(json['hist_district_polygon']).to be_nil }
      it { expect(json['in_district']).to be_false }
      it { expect(json['district_polygon']).to be_nil }

      it { should respond_with 200 }
    end
  end
end
