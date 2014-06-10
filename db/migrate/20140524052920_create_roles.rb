class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.string :rol_nombre
      t.timestamps
    end
  end

  def down
  end
end
