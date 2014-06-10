class CreatePersonasConstructionsRoles < ActiveRecord::Migration
  def up
    create_table :personas_constructions_roles, :id => true do |t|
      t.references :persona
      t.references :construction
      t.references :role
      t.integer :persona_id
      t.integer :construction_id
      t.integer :role_id
      t.timestamps
    end
    add_index(:personas_constructions_roles, [:persona_id, :construction_id, :role_id], :unique => true, :name=>"pers_inm_rol")
  end

  def down
  end
end
