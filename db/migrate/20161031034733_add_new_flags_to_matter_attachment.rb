class AddNewFlagsToMatterAttachment < ActiveRecord::Migration
  def change
    add_column :matter_attachments, :show_on_internet_page, :boolean
    add_column :matter_attachments, :is_minute_order, :boolean
    add_column :matter_attachments, :is_board_letter, :boolean
  end
end
