class CouncilDistrictsController < ApplicationController
  before_action :set_council_district, only: [:show, :edit, :update, :destroy]

  # GET /council_districts
  # GET /council_districts.json
  def index
    @council_districts = CouncilDistrict.all
  end

  # GET /council_districts/1
  # GET /council_districts/1.json
  def show
  end

  def bypoint
    @council_district = CouncilDistrict.bypoint(params[:lat],params[:lng])
    print @council_district.inspect
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_council_district
      @council_district = CouncilDistrict.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def council_district_params
      params[:council_district]
    end
end
