json.array!(@events) do |event|
  json.extract! event, :id, :event_guid, :event_last_modified, :event_last_modified_utc, :event_row_version, :event_body_id, :event_body_name, :event_date, :event_time, :event_video_status, :event_agenda_status_id, :event_minutes_status_id, :event_location
  json.url event_url(event, format: :json)
end
