class CreateDiaries < ActiveRecord::Migration
  def up
    create_table :diaries do |t|
      t.string :age_actividad
      t.date :age_fecha
      t.time :age_hora
      t.string :age_direccion
      t.references :user
      t.integer :user_id
      t.timestamps
    end
    add_index(:diaries, [:user_id], :name=>"usu_age")
  end

  def down
  end
end
