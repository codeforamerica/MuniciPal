class ChangeDateFormatAgainInEvents < ActiveRecord::Migration
  def change
  	execute "ALTER TABLE events ALTER COLUMN \"EventLastModifiedUtc\" TYPE timestamp USING to_timestamp(\"EventLastModifiedUtc\", 'YYYY-MM-DD');"
  end
end

