class CreateMatters < ActiveRecord::Migration
  def change
    create_table :matters do |t|
      t.integer :matterid
      t.integer :matterguid
      t.datetime :matterlastmodifiedutc
      t.string :matterrowversion
      t.string :matterfile
      t.string :mattername
      t.text :mattertitle
      t.integer :mattertypeid
      t.string :mattertypename
      t.integer :matterstatusid
      t.string :matterstatusname
      t.integer :matterbodyid
      t.text :matterbodyname
      t.datetime :matterintrodate
      t.datetime :matteragendadate
      t.datetime :matterpasseddate
      t.datetime :matterenactmentdate
      t.integer :matterenactmentnumber
      t.string :matterrequester
      t.text :matternotes
      t.string :matterversion
      t.text :mattertext1
      t.text :mattertext2
      t.text :mattertext3
      t.text :mattertext4
      t.text :mattertext5
      t.datetime :matterdate1
      t.datetime :matterdate2

      t.timestamps
    end
  end
end
