class CreateProvinces < ActiveRecord::Migration
  def up
    create_table :provinces do |t|
      t.string :prov_nombre
      t.timestamps
    end
  end

  def down
  end
end
