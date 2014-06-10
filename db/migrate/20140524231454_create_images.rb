class CreateImages < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.string :img_path
      t.string :img_path_file_name
      t.string :img_path_content_type
      t.integer :img_path_file_size
      t.references :construction
      t.integer :construction_id
      t.timestamps
    end
    add_index(:images, [:construction_id], :name=>"inm_img")
  end

  def down
  end
end
