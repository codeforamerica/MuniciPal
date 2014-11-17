class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    # ^^^^ + show.json.jbuilder + builder.key_format camelize: :lower in environment.rb  will
    # convert ruby's model_properties into json's modelProperties.
    # Verify by viewing http://localhost:3000/events/1926.json and seeing camelcase, not snakecase.
    # and it replaces the code below:

    # respond_to do |format|
    #   format.html
    #   format.json { render :json => @event }
    # end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:id,
                                    :guid,
                                    :last_modified,
                                    :last_modified_utc,
                                    :row_version,
                                    :body_id,
                                    :body_name,
                                    :date,
                                    :time,
                                    :video_status,
                                    :agenda_status_id,
                                    :minutes_status_id,
                                    :location)
    end
end
