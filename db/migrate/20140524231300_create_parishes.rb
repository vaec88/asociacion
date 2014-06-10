class CreateParishes < ActiveRecord::Migration
  def up
    create_table :parishes do |t|
      t.string :parr_nombre
      t.references :canton
      t.integer :canton_id
      t.timestamps
    end
    add_index(:parishes, [:canton_id], :name=>"cant_parr")
  end

  def down
  end
end
