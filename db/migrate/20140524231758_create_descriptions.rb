class CreateDescriptions < ActiveRecord::Migration
  def up
    create_table :descriptions do |t|
      t.string :param_val_descrip
      t.decimal :param_val_unit
      t.timestamps
    end
  end

  def down
  end
end
