class CreateCantons < ActiveRecord::Migration
  def up
    create_table :cantons do |t|
      t.string :cant_nombre
      t.references :province
      t.integer :province_id
      t.timestamps
    end
    add_index(:cantons, [:province_id], :name=>"prov_cant")
  end

  def down
  end
end
