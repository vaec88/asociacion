class CreateChannels < ActiveRecord::Migration
  def up
    create_table :channels do |t|
      t.string :capt_nombre
      t.timestamps
    end
  end

  def down
  end
end
