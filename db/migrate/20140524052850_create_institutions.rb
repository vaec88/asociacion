class CreateInstitutions < ActiveRecord::Migration
  def up
    create_table :institutions do |t|
      t.string :inst_nombre
      t.string :inst_direccion
      t.string :inst_telefono
      t.timestamps
    end
  end

  def down
  end
end
