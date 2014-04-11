class CreateHistoricDistricts < ActiveRecord::Migration
  def change
    create_table :historic_districts do |t|
			t.string :name
			t.float :acres
	    t.float :shape_leng
			t.float :shape_area
	   	t.geometry :geom
	    t.timestamps    	
    end
  end
end
