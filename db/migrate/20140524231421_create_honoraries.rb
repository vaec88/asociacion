class CreateHonoraries < ActiveRecord::Migration
  def up
    create_table :honoraries do |t|
      t.decimal :hon_cantidad
      t.date :hon_fecha
      t.references :construction
      t.integer :construction_id
      t.timestamps
    end
    add_index(:honoraries, [:construction_id], :name=>"inm_hon")
  end

  def down
  end
end
