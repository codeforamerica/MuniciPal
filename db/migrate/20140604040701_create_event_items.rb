class CreateEventItems < ActiveRecord::Migration
  def change
    create_table :event_items do |t|
      t.integer :source_id
      t.belongs_to :council_district
      t.belongs_to :event
      t.belongs_to :matter
      t.string :guid
      t.datetime :last_modified_utc
      t.string :row_version
      t.integer :agenda_sequence
      t.integer :minutes_sequence
      t.string :agenda_number
      t.integer :video
      t.integer :video_index
      t.string :version
      t.string :agenda_note
      t.string :minutes_note
      t.integer :action_id
      t.text :action_name
      t.text :action_text
      t.integer :passed_flag
      t.string :passed_flag_name
      t.integer :roll_call_flag
      t.integer :flag_extra
      t.text :title
      t.string :tally
      t.integer :consent
      t.integer :mover_id
      t.string :mover
      t.integer :seconder_id
      t.string :seconder
      t.string :matter_guid
      t.string :matter_file
      t.string :matter_name
      t.string :matter_type
      t.string :matter_status
      t.timestamps

      t.timestamps
    end
  end
end
