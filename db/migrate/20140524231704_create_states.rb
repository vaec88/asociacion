class CreateStates < ActiveRecord::Migration
  def up
    create_table :states do |t|
      t.string :met_val_descrip
      t.decimal :met_val_unit
      t.references :rebate
      t.integer :rebate_id
      t.timestamps
    end
    add_index(:states, [:rebate_id], :name=>"rebate_states")
  end

  def down
  end
end
