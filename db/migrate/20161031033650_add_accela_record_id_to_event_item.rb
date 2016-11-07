class AddAccelaRecordIdToEventItem < ActiveRecord::Migration
  def change
    add_column :event_items, :accela_record_id, :string
  end
end
