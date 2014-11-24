class CreateCouncilDistricts < ActiveRecord::Migration
  def change
    create_table :council_districts, options={id: false } do |t|
      t.primary_key   :id 
      t.string        :name
      t.string	      :twit_name
      t.string	      :twit_wdgt
      t.timestamps  
    end
  end
end
