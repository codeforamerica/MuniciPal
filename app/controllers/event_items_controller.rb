class EventItemsController < ApplicationController
  before_action :set_event_item, only: [:show, :edit, :update, :destroy]

  # GET /event_items
  # GET /event_items.json
  # def index
  #   # @council_district = CouncilDistrict.find(params[:council_district_id])
  #   # @event_items = @council_district.event_items

  #   # respond_to do |format|
  #   #   format.html # index.html.erb
  #   #   format.json { render :json => @lines }
  #   # end
  #   @event_items = EventItem.all
  # end
  def index
    # EventItem.find([34418, 34433])
    @event_items = EventItem.all
  end

  # GET /event_items/1
  # GET /event_items/1.json
  def show
    EventItem.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_item
      @event_item = EventItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_item_params
      params.require(:event_item).permit(:id,
                                         :event_id,
                                         :guid,
                                         :last_modified,
                                         :last_modified_utc,
                                         :row_version,
                                         :agenda_sequence,
                                         :minutes_sequence,
                                         :agenda_number,
                                         :video,
                                         :video_index,
                                         :version,
                                         :agenda_note,
                                         :minutes_note,
                                         :action_id,
                                         :action,
                                         :action_text,
                                         :passed_flag,
                                         :passed_flag_text,
                                         :roll_call_flag,
                                         :flag_extra,
                                         :title,
                                         :tally,
                                         :consent,
                                         :mover_id,
                                         :mover,
                                         :seconder_id,
                                         :seconder,
                                         :matter_id,
                                         :matter_guid,
                                         :matter_file,
                                         :matter_name,
                                         :matter_type,
                                         :matter_status)
    end
end
