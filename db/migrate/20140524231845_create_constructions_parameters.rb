class CreateConstructionsParameters < ActiveRecord::Migration
  def up
    create_table :constructions_parameters, :id => true do |t|
      t.references :construction
      t.references :parameter
      t.references :description
      t.integer :construction_id
      t.integer :parameter_id
      t.integer :description_id
      t.timestamps
    end
    add_index(:constructions_parameters, [:construction_id, :parameter_id], :unique => true, :name=>"inm_param")
    add_index(:constructions_parameters, [:description_id], :name=>"descrip_inm_param")
  end

  def down
  end
end
