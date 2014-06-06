class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :EventId
      t.string :EventGuid
      t.string :EventLastModified
      t.string :EventLastModifiedUtc
      t.string :EventRowVersion
      t.integer :EventBodyId
      t.string :EventBodyName
      t.string :EventDate
      t.string :EventTime
      t.string :EventVideoStatus
      t.integer :EventAgendaStatusId
      t.integer :EventMinutesStatusId
      t.string :EventLocation

      t.timestamps
    end
  end
end
