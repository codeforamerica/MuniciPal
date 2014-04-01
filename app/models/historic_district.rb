class HistoricDistrict < ActiveRecord::Base
	self.primary_key = 'gid'
	self.table_name = 'historicdistricts'

	COORD_SYS_REF = 4326;		# The coordinate system that will be used as the reference and is now Latitude and Longitude Coord System
	COORD_SYS_AREA = 2278;	# The coordinate system used in the data Texas South Central Coordinate System
	COORD_SYS_ZONE = 0;			# The coordinate system used in the actual data but somehow it was wiped to 0, so put it back into the same one to check

	def self.inDistrict? lat, long
		# figure out if it is in a specific area in 
		@spec_area = HistoricDistrict.where("ST_Contains(geom, ST_SetSRID(ST_Transform(ST_SetSRID(ST_MakePoint(?, ?), ?), ?), ?))",
																							long,
																							lat,
																							COORD_SYS_REF,
																							COORD_SYS_AREA,
																							COORD_SYS_ZONE)

		return @spec_area.exists?
	end
	#select * from historicdistricts where ST_Contains(historicdistricts.geom, ST_SetSRID(ST_Transform(ST_SetSRID(ST_MakePoint(-98.491842, 29.414678),4326), 2278), 0));
end