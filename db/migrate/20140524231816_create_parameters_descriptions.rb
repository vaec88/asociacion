class CreateParametersDescriptions < ActiveRecord::Migration
  def up
    create_table :parameters_descriptions, :id => false do |t|
      t.references :parameter
      t.references :description
      t.integer :parameter_id
      t.integer :description_id
      t.timestamps
    end
    add_index(:parameters_descriptions, [:parameter_id, :description_id], :unique => true, :name=>"param_descrip")
  end

  def down
  end
end
