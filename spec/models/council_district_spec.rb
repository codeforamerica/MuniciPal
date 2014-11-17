require 'spec_helper'
require 'rake'

describe CouncilDistrict do

  before(:all) do 
    @city_council_1 = FactoryGirl.create(:council_district)
  end

  describe ".inDistrict?" do
    context 'when lat lng is in' do
      # Lat lng of 302 Madison St, San Antonio
      let (:answer) { CouncilDistrict.inDistrict? 29.414432, -98.491916 }

      it { expect(answer).to be_true }
    end

    context 'when lat lng is not in' do
      # Lat lng of 155 9th St, San Francisco
      let (:answer) { CouncilDistrict.inDistrict? 37.775518,-122.413821 }

      it { expect(answer).to be_false }
    end
  end

  describe ".getDistrict" do
    context 'when lat lng is in' do
      # Lat lng of 302 Madison St, San Antonio
      let (:district) { CouncilDistrict.getDistrict 29.414432, -98.491916 }

      it { expect(district.district).to be(1) }
      it { expect(district.name).to be == "Diego M. Bernal" }
    end

    context 'when lat lng is not in' do
      # Lat lng of 155 9th St, San Francisco
      let (:district) { CouncilDistrict.getDistrict 37.775518,-122.413821 }

      it { expect(district).to be_nil }
    end
  end

  after(:all) do
    @city_council_1.destroy
  end

end
