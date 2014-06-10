class CreatePieces < ActiveRecord::Migration
  def up
    create_table :pieces do |t|
      t.string :part_nombre
      t.timestamps
    end
  end

  def down
  end
end
