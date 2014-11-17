class MattersController < ApplicationController
  before_action :set_matter, only: [:show, :edit, :update, :destroy]

  # GET /matters
  # GET /matters.json
  def index
    @matters = Matter.all
  end

  # GET /matters/1
  # GET /matters/1.json
  def show
    puts params
    @matter = Matter.find(params["id"])
    @event_item = @matter.event_items.first
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matter
      @matter = Matter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matter_params
      params.require(:matter).permit(:MatterId, :guid, :last_modified_utc, :row_version, :file, :name, :title, :type_id, :type_name, :status_id, :status_name, :body_id, :body_name, :intro_date, :agenda_date, :passed_date, :enactment_date, :enactment_number, :requester, :notes, :version, :text1, :text2, :text3, :text4, :text5, :date1, :date2)
    end
end
