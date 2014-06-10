class CreateConstructionsPrices < ActiveRecord::Migration
  def up
    create_table :constructions_prices, :id => true do |t|
      t.references :construction
      t.references :price
      t.integer :construction_id
      t.integer :price_id
      t.decimal :det_area
      t.decimal :det_val_unit
      t.decimal :det_val_tot
      t.timestamps
    end
    add_index(:constructions_prices, [:construction_id, :price_id], :unique => true, :name=>"inm_aval")
  end

  def down
  end
end
