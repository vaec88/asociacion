class CreateOperations < ActiveRecord::Migration
  def up
    create_table :operations do |t|
      t.string :oper_nombre
      t.timestamps
    end
  end

  def down
  end
end
