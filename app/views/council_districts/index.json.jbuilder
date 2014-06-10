json.array!(@council_districts) do |council_district|
  json.extract! council_district, :id
  json.url council_district_url(council_district, format: :json)
end
