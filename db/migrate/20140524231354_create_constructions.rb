class CreateConstructions < ActiveRecord::Migration
  def up
    create_table :constructions do |t|
      t.string :inm_ciudadela
      t.string :inm_calle
      t.decimal :latitude
      t.decimal :longitude
      t.string :inm_conjunto
      t.integer :inm_vivienda
      t.string :inm_unid_med
      t.string :inm_estado
      t.decimal :inm_val_real
      t.decimal :inm_val_merc
      t.string :inm_forma_pago
      t.decimal :inm_val_honor
      t.references :operation
      t.integer :operation_id
      t.references :property
      t.integer :property_id
      t.references :parish
      t.integer :parish_id
      t.timestamps
    end
    add_index(:constructions, [:operation_id, :property_id, :parish_id], :name=>"oper_propd_parr_inm")
  end

  def down
  end
end
