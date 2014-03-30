class HistoricDistrict < ActiveRecord::Base
	self.primary_key = 'gid'
	self.table_name = 'historicdistricts'

	def in_historic_district? lat long
		HistoricDistrict.connection.execute("select * from historicdistricts where ST_Contains(historicdistricts.geom, ST_SetSRID(ST_Transform(ST_GeomFromText('POINT(-98.491842 29.414678)',4326), 2278), 0));")
	end
end
