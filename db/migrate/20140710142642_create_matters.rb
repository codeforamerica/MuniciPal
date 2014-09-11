class CreateMatters < ActiveRecord::Migration
  def change
    create_table :matters do |t|
      t.integer :source_id
      t.string :guid
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
      t.string :enactment_number
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
      t.text :ex_text1
      t.text :ex_text2
      t.text :ex_text3
      t.text :ex_text4
      t.text :ex_text5
      t.text :ex_text6
      t.text :ex_text7
      t.text :ex_text8
      t.text :ex_text9
      t.text :ex_text10
      t.datetime :ex_date1
      t.datetime :ex_date2
      t.datetime :ex_date3
      t.datetime :ex_date4
      t.datetime :ex_date5
      t.datetime :ex_date6
      t.datetime :ex_date7
      t.datetime :ex_date8
      t.datetime :ex_date9
      t.datetime :ex_date10
      t.timestamps
    end
  end
end
