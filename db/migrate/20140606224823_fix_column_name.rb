class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :event_items, :council_district_id, :council_council_district_id
  	remove_column :council_districts, :id
  	rename_column :council_districts, :district, :id
  end
end
