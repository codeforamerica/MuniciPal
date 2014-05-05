require 'spec_helper'
require 'rake'

describe CosaCouncilDistrict do

  before(:all) do 
    @city_council_1 = FactoryGirl.create(:cosa_council_district)
  end

  describe ".inDistrict?" do
    context 'when lat long is in' do
      # Lat Long of 302 Madison St, San Antonio
      let (:answer) { CosaCouncilDistrict.inDistrict? 29.414432, -98.491916 }

      it { expect(answer).to be_true }
    end

    context 'when lat long is not in' do
      # Lat Long of 155 9th St, San Francisco
      let (:answer) { CosaCouncilDistrict.inDistrict? 37.775518,-122.413821 }

      it { expect(answer).to be_false }
    end
  end

  describe ".getDistrict" do
    context 'when lat long is in' do
      # Lat Long of 302 Madison St, San Antonio
      let (:district) { CosaCouncilDistrict.getDistrict 29.414432, -98.491916 }

      it { expect(district.district).to be(1) }
      it { expect(district.name).to be == "Diego M. Bernal" }
    end

    context 'when lat long is not in' do
      # Lat Long of 155 9th St, San Francisco
      let (:district) { CosaCouncilDistrict.getDistrict 37.775518,-122.413821 }

      it { expect(district).to be_nil }
    end
  end

  after(:all) do
    @city_council_1.destroy
  end

end
