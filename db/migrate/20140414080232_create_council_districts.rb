class CreateCouncilDistricts < ActiveRecord::Migration
  def change
    create_table :council_districts do |t|
      t.integer   :district
      t.string    :name
      t.geometry  :geom
      t.timestamps  
    end
  end
end
