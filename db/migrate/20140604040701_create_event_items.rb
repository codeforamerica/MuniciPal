class CreateEventItems < ActiveRecord::Migration
  def change
    create_table :event_items do |t|
      t.integer :event_id
      t.integer :council_district_id
      t.integer :EventItemId
      t.string :EventItemGuid
      t.string :EventItemLastModified
      t.string :EventItemLastModifiedUtc
      t.string :EventItemRowVersion
      t.integer :EventItemEventId
      t.integer :EventItemAgendaSequence
      t.integer :EventItemMinutesSequence
      t.string :EventItemAgendaNumber
      t.string :EventItemVideo
      t.integer :EventItemVideoIndex
      t.string :EventItemVersion
      t.string :EventItemAgendaNote
      t.string :EventItemMinutesNote
      t.integer :EventItemActionId
      t.string :EventItemAction
      t.text :EventItemActionText
      t.integer :EventItemPassedFlag
      t.string :EventItemPassedFlagText
      t.integer :EventItemRollCallFlag
      t.string :EventItemFlagExtra
      t.text :EventItemTitle
      t.integer :EventItemTally
      t.integer :EventItemConsent
      t.integer :EventItemMoverId
      t.string :EventItemMover
      t.integer :EventItemSeconderId
      t.string :EventItemSeconder
      t.integer :EventItemMatterId
      t.string :EventItemMatterGuid
      t.string :EventItemMatterFile
      t.string :EventItemMatterName
      t.string :EventItemMatterType
      t.string :EventItemMatterStatus

      t.timestamps
    end
  end
end
