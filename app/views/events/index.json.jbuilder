json.array!(@events) do |event|
  json.extract! event, :id, :EventId, :EventGuid, :EventLastModified, :EventLastModifiedUtc, :EventRowVersion, :EventBodyId, :EventBodyName, :EventDate, :EventTime, :EventVideoStatus, :EventAgendaStatusId, :EventMinutesStatusId, :EventLocation
  json.url event_url(event, format: :json)
end
