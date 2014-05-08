class EnablePostgis < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION IF NOT EXISTS postgis;"
  end
  def change
  	enable_extension :postgis
  end
end
