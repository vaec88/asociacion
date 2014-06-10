class CreatePrices < ActiveRecord::Migration
  def up
    create_table :prices do |t|
      t.string :aval_descrip
      t.timestamps
    end
  end

  def down
  end
end
