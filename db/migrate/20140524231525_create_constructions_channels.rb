class CreateConstructionsChannels < ActiveRecord::Migration
  def up
    create_table :constructions_channels, :id => true  do |t|
      t.references :construction
      t.references :channel
      t.integer :construction_id
      t.integer :channel_id
      t.timestamps
    end
    add_index(:constructions_channels, [:construction_id, :channel_id], :unique => true, :name=>"inm_capt")
  end

  def down
  end
end
