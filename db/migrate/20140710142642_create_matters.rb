class CreateMatters < ActiveRecord::Migration
  def change
    create_table :matters do |t|
      t.integer :MatterId
      t.integer :guid
      t.datetime :last_modified_utc
      t.string :row_version
      t.string :file
      t.string :name
      t.text :title
      t.integer :type_id
      t.string :type_name
      t.integer :status_id
      t.string :status_name
      t.integer :body_id
      t.text :body_name
      t.datetime :intro_date
      t.datetime :agenda_date
      t.datetime :passed_date
      t.datetime :enactment_date
      t.integer :enactment_number
      t.string :requester
      t.text :notes
      t.string :version
      t.text :text1
      t.text :text2
      t.text :text3
      t.text :text4
      t.text :text5
      t.datetime :date1
      t.datetime :date2

      t.timestamps
    end
  end
end
