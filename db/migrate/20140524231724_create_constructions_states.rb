class CreateConstructionsStates < ActiveRecord::Migration
  def up
    create_table :constructions_states, :id => true do |t|
      t.references :construction
      t.references :state
      t.integer :construction_id
      t.integer :state_id
      t.timestamps
    end
    add_index(:constructions_states, [:construction_id, :state_id], :unique => true, :name=>"inm_state")
  end

  def down
  end
end
