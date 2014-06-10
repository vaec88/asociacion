class CreateParameters < ActiveRecord::Migration
  def up
    create_table :parameters do |t|
      t.string :param_descrip
      t.timestamps
    end
  end

  def down
  end
end
