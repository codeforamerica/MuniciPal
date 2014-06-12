class ChangeDateFormatInEvents < ActiveRecord::Migration
  def change
  	execute "ALTER TABLE events ALTER COLUMN \"EventDate\" TYPE timestamp USING to_timestamp(\"EventDate\", 'YYYY-MM-DD');"
  end
end

