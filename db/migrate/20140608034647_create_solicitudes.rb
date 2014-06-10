class CreateSolicitudes < ActiveRecord::Migration
  def up
    create_table :solicitudes do |t|
      t.string :sol_nombre
      t.string :sol_apellido
      t.string :sol_email
      t.string :sol_msg
      t.date :sol_fecha
      t.references :construction
      t.integer :construction_id
      t.timestamps
    end
    add_index(:solicitudes, [:construction_id], :name=>"inm_sol")
  end
end
