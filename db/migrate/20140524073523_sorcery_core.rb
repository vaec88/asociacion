class SorceryCore < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username,         :null => false  # if you use another field as a username, for example email, you can safely remove this field.
      t.string :email,            :default => nil # if you use this field as a username, you might want to make it :null => false.
      t.string :crypted_password, :default => nil
      t.string :salt,             :default => nil
      t.string :usu_foto
      t.string :usu_foto_file_name
      t.string :usu_foto_content_type
      t.integer :usu_foto_file_size
      t.string :usu_estado
      t.string :usu_matr_prof
      t.string :usu_pag_web
      t.integer :institution_id
      t.references :institution
      t.timestamps
    end
    add_index(:users, [:institution_id], :name=>"inst_usu")
  end

  def self.down
    drop_table :users
  end
end