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

  # GET /council_districts/new
  def new
    @council_district = CouncilDistrict.new
  end

  # GET /council_districts/1/edit
  def edit
  end

  # POST /council_districts
  # POST /council_districts.json
  def create
    @council_district = CouncilDistrict.new(council_district_params)

    respond_to do |format|
      if @council_district.save
        format.html { redirect_to @council_district, notice: 'Council district was successfully created.' }
        format.json { render action: 'show', status: :created, location: @council_district }
      else
        format.html { render action: 'new' }
        format.json { render json: @council_district.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /council_districts/1
  # PATCH/PUT /council_districts/1.json
  def update
    respond_to do |format|
      if @council_district.update(council_district_params)
        format.html { redirect_to @council_district, notice: 'Council district was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @council_district.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /council_districts/1
  # DELETE /council_districts/1.json
  def destroy
    @council_district.destroy
    respond_to do |format|
      format.html { redirect_to council_districts_url }
      format.json { head :no_content }
    end
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
