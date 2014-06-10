class CreatePersonas < ActiveRecord::Migration
  def up
    create_table :personas do |t|
      t.string :pers_cedula
      t.string :pers_apellido
      t.string :pers_nombre
      t.string :pers_direccion
      t.string :pers_telefono1
      t.string :pers_telefono2
      t.string :pers_email
      t.string :pers_estado
      t.timestamps
    end
  end

  def down
  end
end
