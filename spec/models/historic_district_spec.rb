require 'spec_helper'
require 'rake'

describe HistoricDistrict do

  before(:all) do 
    @king_william = FactoryGirl.create(:historic_district)
  end

  describe ".inDistrict?" do
    context 'when lat long is in' do
      # Lat Long of 302 Madison St, San Antonio
      let (:answer) { HistoricDistrict.inDistrict? 29.414432, -98.491916 }

      it { expect(answer).to be_true }
    end

    context 'when lat long is not in' do
      # Lat Long of 155 9th St, San Francisco
      let (:answer) { HistoricDistrict.inDistrict? 37.775518,-122.413821 }

      it { expect(answer).to be_false }
    end
  end

  describe ".getDistrict" do
    context 'when lat long is in' do
      # Lat Long of 302 Madison St, San Antonio
      let (:district) { HistoricDistrict.getDistrict 29.414432, -98.491916 }

      it { expect(district.name).to be == "King William" }
    end

    context 'when lat long is not in' do
      # Lat Long of 155 9th St, San Francisco
      let (:district) { HistoricDistrict.getDistrict 37.775518,-122.413821 }

      it { expect(district).to be_nil }
    end
  end

  after(:all) do
    @king_william.destroy
  end

end