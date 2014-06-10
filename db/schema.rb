# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140608034647) do

  create_table "amounts", :force => true do |t|
    t.decimal  "amo_cantidad"
    t.integer  "amo_mes"
    t.integer  "amo_anio"
    t.date     "amo_fecha"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "amounts", ["user_id"], :name => "usu_amo"

  create_table "cantons", :force => true do |t|
    t.string   "cant_nombre"
    t.integer  "province_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "cantons", ["province_id"], :name => "prov_cant"

  create_table "channels", :force => true do |t|
    t.string   "capt_nombre"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "constructions", :force => true do |t|
    t.string   "inm_ciudadela"
    t.string   "inm_calle"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "inm_conjunto"
    t.integer  "inm_vivienda"
    t.string   "inm_unid_med"
    t.string   "inm_estado"
    t.decimal  "inm_val_real"
    t.decimal  "inm_val_merc"
    t.string   "inm_forma_pago"
    t.decimal  "inm_val_honor"
    t.integer  "operation_id"
    t.integer  "property_id"
    t.integer  "parish_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "constructions", ["operation_id", "property_id", "parish_id"], :name => "oper_propd_parr_inm"

  create_table "constructions_channels", :force => true do |t|
    t.integer  "construction_id"
    t.integer  "channel_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "constructions_channels", ["construction_id", "channel_id"], :name => "inm_capt", :unique => true

  create_table "constructions_parameters", :force => true do |t|
    t.integer  "construction_id"
    t.integer  "parameter_id"
    t.integer  "description_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "constructions_parameters", ["construction_id", "parameter_id"], :name => "inm_param", :unique => true
  add_index "constructions_parameters", ["description_id"], :name => "descrip_inm_param"

  create_table "constructions_pieces", :force => true do |t|
    t.integer  "construction_id"
    t.integer  "piece_id"
    t.integer  "det_numero"
    t.string   "det_descrip"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "constructions_pieces", ["construction_id", "piece_id"], :name => "inm_part", :unique => true

  create_table "constructions_prices", :force => true do |t|
    t.integer  "construction_id"
    t.integer  "price_id"
    t.decimal  "det_area"
    t.decimal  "det_val_unit"
    t.decimal  "det_val_tot"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "constructions_prices", ["construction_id", "price_id"], :name => "inm_aval", :unique => true

  create_table "constructions_states", :force => true do |t|
    t.integer  "construction_id"
    t.integer  "state_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "constructions_states", ["construction_id", "state_id"], :name => "inm_state", :unique => true

  create_table "descriptions", :force => true do |t|
    t.string   "param_val_descrip"
    t.decimal  "param_val_unit"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "diaries", :force => true do |t|
    t.string   "age_actividad"
    t.date     "age_fecha"
    t.time     "age_hora"
    t.string   "age_direccion"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "diaries", ["user_id"], :name => "usu_age"

  create_table "honoraries", :force => true do |t|
    t.decimal  "hon_cantidad"
    t.date     "hon_fecha"
    t.integer  "construction_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "honoraries", ["construction_id"], :name => "inm_hon"

  create_table "images", :force => true do |t|
    t.string   "img_path"
    t.string   "img_path_file_name"
    t.string   "img_path_content_type"
    t.integer  "img_path_file_size"
    t.integer  "construction_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "images", ["construction_id"], :name => "inm_img"

  create_table "institutions", :force => true do |t|
    t.string   "inst_nombre"
    t.string   "inst_direccion"
    t.string   "inst_telefono"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "meetings", :force => true do |t|
    t.string   "reu_actores"
    t.string   "reu_detalle"
    t.datetime "reu_fecha_hora"
    t.string   "reu_estado"
    t.integer  "construction_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "meetings", ["construction_id"], :name => "inm_reu"

  create_table "operations", :force => true do |t|
    t.string   "oper_nombre"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "parameters", :force => true do |t|
    t.string   "param_descrip"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "parameters_descriptions", :id => false, :force => true do |t|
    t.integer  "parameter_id"
    t.integer  "description_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "parameters_descriptions", ["parameter_id", "description_id"], :name => "param_descrip", :unique => true

  create_table "parishes", :force => true do |t|
    t.string   "parr_nombre"
    t.integer  "canton_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "parishes", ["canton_id"], :name => "cant_parr"

  create_table "personas", :force => true do |t|
    t.string   "pers_cedula"
    t.string   "pers_apellido"
    t.string   "pers_nombre"
    t.string   "pers_direccion"
    t.string   "pers_telefono1"
    t.string   "pers_telefono2"
    t.string   "pers_email"
    t.string   "pers_estado"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "personas_constructions_roles", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "construction_id"
    t.integer  "role_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "personas_constructions_roles", ["persona_id", "construction_id", "role_id"], :name => "pers_inm_rol", :unique => true

  create_table "personas_roles_users", :force => true do |t|
    t.integer  "persona_id"
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "personas_roles_users", ["persona_id", "role_id", "user_id"], :name => "pers_rol_usu", :unique => true

  create_table "pieces", :force => true do |t|
    t.string   "part_nombre"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "prices", :force => true do |t|
    t.string   "aval_descrip"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "properties", :force => true do |t|
    t.string   "propd_nombre"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "provinces", :force => true do |t|
    t.string   "prov_nombre"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rebates", :force => true do |t|
    t.string   "met_nombre"
    t.integer  "met_nivel"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "rol_nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "solicitudes", :force => true do |t|
    t.string   "sol_nombre"
    t.string   "sol_apellido"
    t.string   "sol_email"
    t.string   "sol_msg"
    t.date     "sol_fecha"
    t.integer  "construction_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "solicitudes", ["construction_id"], :name => "inm_sol"

  create_table "states", :force => true do |t|
    t.string   "met_val_descrip"
    t.decimal  "met_val_unit"
    t.integer  "rebate_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "states", ["rebate_id"], :name => "rebate_states"

  create_table "users", :force => true do |t|
    t.string   "username",                        :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "usu_foto"
    t.string   "usu_foto_file_name"
    t.string   "usu_foto_content_type"
    t.integer  "usu_foto_file_size"
    t.string   "usu_estado"
    t.string   "usu_matr_prof"
    t.string   "usu_pag_web"
    t.integer  "institution_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["institution_id"], :name => "inst_usu"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
