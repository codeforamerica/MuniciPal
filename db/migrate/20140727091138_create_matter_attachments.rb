class CreateMatterAttachments < ActiveRecord::Migration
  def change
    create_table :matter_attachments do |t|
      t.integer :source_id
      t.belongs_to :matter
      t.text :guid
      t.datetime :last_modified_utc
      t.text :row_version
      t.text :name
      t.text :hyperlink
      t.text :file_name
      t.text :matter_version
      t.boolean :is_hyperlink
      t.string :binary
      t.timestamps
    end
  end
end
