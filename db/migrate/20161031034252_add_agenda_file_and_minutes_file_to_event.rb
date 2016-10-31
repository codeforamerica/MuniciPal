class AddAgendaFileAndMinutesFileToEvent < ActiveRecord::Migration
  def change
    add_column :events, :agenda_file, :string
    add_column :events, :minutes_file, :string
    add_column :events, :agenda_last_published_utc, :datetime
    add_column :events, :minutes_last_published_utc, :datetime
  end
end
