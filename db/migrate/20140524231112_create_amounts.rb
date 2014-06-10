class CreateAmounts < ActiveRecord::Migration
  def up
    create_table :amounts do |t|
      t.decimal :amo_cantidad
      t.integer :amo_mes
      t.integer :amo_anio
      t.date :amo_fecha
      t.references :user
      t.integer :user_id
      t.timestamps
    end
    add_index(:amounts, [:user_id], :name=>"usu_amo")
  end

  def down
  end
end
