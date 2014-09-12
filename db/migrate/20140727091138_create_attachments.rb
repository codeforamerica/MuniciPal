class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :source_id
      t.belongs_to :matter
      t.text :guid
      t.datetime :last_modified_utc
      t.text :row_version
      t.text :name
      t.text :hyperlink
      t.text :filename
      t.text :matter_version
      t.boolean :is_hyperlink
      t.binary :binary

      t.timestamps
    end
  end
end
