class CreateConstructionsPieces < ActiveRecord::Migration
  def up
    create_table :constructions_pieces, :id => true do |t|
      t.references :construction
      t.references :piece
      t.integer :construction_id
      t.integer :piece_id
      t.integer :det_numero
      t.string :det_descrip
      t.timestamps
    end
    add_index(:constructions_pieces, [:construction_id, :piece_id], :unique => true, :name=>"inm_part")
  end

  def down
  end
end
