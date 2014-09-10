class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :source_id
      t.string :guid
      t.string :last_modified
      t.string :last_modified_utc
      t.string :row_version
      t.integer :body_id
      t.string :body_name
      t.datetime :date
      t.string :time
      t.string :video_status
      t.integer :agenda_status_id
      t.integer :minutes_status_id
      t.string :location

      t.timestamps
    end
  end
end
