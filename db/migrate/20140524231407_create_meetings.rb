class CreateMeetings < ActiveRecord::Migration
  def up
    create_table :meetings do |t|
      t.string :reu_actores
      t.string :reu_detalle
      t.datetime :reu_fecha_hora
      t.string :reu_estado
      t.references :construction
      t.integer :construction_id
      t.timestamps
    end
    add_index(:meetings, [:construction_id], :name=>"inm_reu")
  end

  def down
  end
end
