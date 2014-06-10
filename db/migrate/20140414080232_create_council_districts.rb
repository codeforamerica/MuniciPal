class CreateCouncilDistricts < ActiveRecord::Migration
  def change
    create_table :council_districts do |t|
      t.string    :name
      t.string	  :twit_name
      t.string	  :twit_wdgt
      t.geometry  :geom
      t.timestamps  
    end
  end
end
