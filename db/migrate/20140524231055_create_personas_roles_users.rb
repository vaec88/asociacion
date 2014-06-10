class CreatePersonasRolesUsers < ActiveRecord::Migration
  def up
    create_table :personas_roles_users, :id => true do |t|
      t.references :persona
      t.references :role
      t.references :user
      t.integer :persona_id
      t.integer :role_id
      t.integer :user_id
      t.timestamps
    end
    add_index(:personas_roles_users, [:persona_id, :role_id, :user_id], :unique => true, :name=>"pers_rol_usu")
  end

  def down
  end
end
