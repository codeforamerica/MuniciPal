class AddDistrictIdToEventItems < ActiveRecord::Migration
  def change
    add_column :event_items, :council_district_id, :integer
  end
end
