class CreateProperties < ActiveRecord::Migration
  def up
    create_table :properties do |t|
      t.string :propd_nombre
      t.timestamps
    end
  end

  def down
  end
end
