class CreateRebates < ActiveRecord::Migration
  def up
    create_table :rebates do |t|
      t.string :met_nombre
      t.integer :met_nivel
      t.timestamps
    end
  end

  def down
  end
end
