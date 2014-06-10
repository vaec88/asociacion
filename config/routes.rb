Acbro::Application.routes.draw do
  get "password_resets/create"

  get "password_resets/edit"

  get "password_resets/update"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  
 #  match ':controller(/:action(/:id))(.:format)'

  root :to => "principal#index"

  get "ruta_prueba" => "sessions#new", :as => "ruta_prueba"

  #SOLICITUDES DE VISITANTES A CORREDORES
  get "solicitud_construction" => "solicitudes#solicitud_construction", :as => "solicitud_construction"
  get "index_solicitude" => "solicitudes#index", :as => "index_solicitude"
  post "destroy_solicitude" => "solicitudes#destroy", :as => "destroy_solicitude"
  post "reporte_solicitude" => "solicitudes#reporte_solicitude", :as => "reporte_solicitude"
  

  #PRINCIPAL INFORMATIVO
  get "index" => "principal#index", :as => "index"
  get "ingresaste" => "principal#ingresaste", :as => "ingresaste"
  get "falla_sesion" => "principal#falla_sesion", :as => "falla_sesion"
  get "deudas" => "principal#deudas", :as => "deudas"
  get "cuenta_inactiva" => "principal#cuenta_inactiva", :as => "cuenta_inactiva"
  get "mision" => "principal#mision", :as => "mision"
  get "vision" => "principal#vision", :as => "vision"
  get "directivos" => "principal#directivos", :as => "directivos"
  get "resena" => "principal#resena", :as => "resena"
  get "etica" => "principal#etica", :as => "etica"
  get "ley" => "principal#ley", :as => "ley"
  get "reglamento" => "principal#reglamento", :as => "reglamento"
  get "novedades" => "principal#novedades", :as => "novedades"
  get "propiedades" => "principal#propiedades", :as => "propiedades"
  get "contacto" => "principal#contacto", :as => "contacto"
  get "denegado" => "principal#denegado", :as => "denegado"

  #SESIONES
  get "log_in" => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  
  #PERSONAS
  get "lista" => "personas#lista", :as => "lista"
  get "new_person" => "personas#new", :as => "new_person"
  get "index_person" => "personas#index", :as => "index_person"
  get 'personas/update_demandante', :as => 'update_demandante'
  post "reporte_demandante" => "personas#reporte_demandante", :as => "reporte_demandante"


  #USUARIOS
  get "index_usuarios" => "users#index", :as => "index_usuarios"
  get "sing_up" => "users#new", :as => "sing_up"
  get "activar_cuentas" => "users#activar_cuentas", :as => "activar_cuentas"
  get "edit_usuarios" => "users#edit", :as => "edit_usuarios"
  get 'users/usu_username_check', :as => 'usu_username_check'
  get 'users/usu_matr_prof_check', :as => 'usu_matr_prof_check'
  get 'users/pers_cedula_check', :as => 'pers_cedula_check'
  get 'users/pers_email_check', :as => 'pers_email_check'
  get 'users/edit_password', :as => 'edit_password'
  post "destroy_usuario" => "users#destroy", :as => "destroy_usuario"
  post "reporte_amount" => "users#reporte_amount", :as => "reporte_amount"
  
  #ROLES
  get "index_role" => "roles#index", :as => "index_role"
  get "new_role" => "roles#new", :as => "new_role"
  get "edit_role" => "roles#edit", :as => "edit_role"
  get "show_role" => "roles#show", :as => "show_role"
  post "destroy_role" => "roles#destroy", :as => "destroy_role"

  #TIPOS DE PROPIEDADES
  get "index_property" => "properties#index", :as => "index_property"
  get "new_property" => "properties#new", :as => "new_property"
  get "edit_property" => "properties#edit", :as => "edit_property"
  get "show_property" => "properties#show", :as => "show_property"
  post "destroy_property" => "properties#destroy", :as => "destroy_property"

  #TIPOS DE OPERACIONES
  get "index_operation" => "operations#index", :as => "index_operation"
  get "new_operation" => "operations#new", :as => "new_operation"
  get "edit_operation" => "operations#edit", :as => "edit_operation"
  get "show_operation" => "operations#show", :as => "show_operation"
  post "destroy_operation" => "operations#destroy", :as => "destroy_operation"

  #MEDIOS DE CAPTACION
  get "index_channel" => "channels#index", :as => "index_channel"
  get "new_channel" => "channels#new", :as => "new_channel"
  get "edit_channel" => "channels#edit", :as => "edit_channel"
  get "show_channel" => "channels#show", :as => "show_channel"
  post "destroy_channel" => "channels#destroy", :as => "destroy_channel"

  #PROVINCIAS
  get "index_province" => "provinces#index", :as => "index_province"
  get "new_province" => "provinces#new", :as => "new_province"
  get "edit_province" => "provinces#edit", :as => "edit_province"
  get "show_province" => "provinces#show", :as => "show_province"
  post "destroy_province" => "provinces#destroy", :as => "destroy_province"


  #CANTONES
  get "index_canton" => "cantons#index", :as => "index_canton"
  get "new_canton" => "cantons#new", :as => "new_canton"
  get "edit_canton" => "cantons#edit", :as => "edit_canton"
  get "show_canton" => "cantons#show", :as => "show_canton"
  post "destroy_canton" => "cantons#destroy", :as => "destroy_canton"

  #PARROQUIAS
  get "index_parish" => "parishes#index", :as => "index_parish"
  get "new_parish" => "parishes#new", :as => "new_parish"
  get "edit_parish" => "parishes#edit", :as => "edit_parish"
  get "show_parish" => "parishes#show", :as => "show_parish"
  post "destroy_parish" => "parishes#destroy", :as => "destroy_parish"

  #PARTES
  get "index_piece" => "pieces#index", :as => "index_piece"
  get "new_piece" => "pieces#new", :as => "new_piece"
  get "edit_piece" => "pieces#edit", :as => "edit_piece"
  get "show_piece" => "pieces#show", :as => "show_piece"
  post "destroy_piece" => "pieces#destroy", :as => "destroy_piece"

  #TABLA DE AVALUO
  get "index_price" => "prices#index", :as => "index_price"
  get "new_price" => "prices#new", :as => "new_price"
  get "edit_price" => "prices#edit", :as => "edit_price"
  get "show_price" => "prices#show", :as => "show_price"
  post "destroy_price" => "prices#destroy", :as => "destroy_price"


  #PARAMETROS DE AVALUO
  get "index_parameter" => "parameters#index", :as => "index_parameter"
  get "new_parameter" => "parameters#new", :as => "new_parameter"
  get "edit_parameter" => "parameters#edit", :as => "edit_parameter"
  get "show_parameter" => "parameters#show", :as => "show_parameter"
  post "destroy_parameter" => "parameters#destroy", :as => "destroy_parameter"

  #VALORES DE LOS PARAMETROS DE AVALUO
  get "index_description" => "descriptions#index", :as => "index_description"
  get "new_description" => "descriptions#new", :as => "new_description"
  get "edit_description" => "descriptions#edit", :as => "edit_description"
  get "show_description" => "descriptions#show", :as => "show_description"
  post "destroy_description" => "descriptions#destroy", :as => "destroy_description"

  #DEPRECIACIONES
  get "index_rebate" => "rebates#index", :as => "index_rebate"
  get "new_rebate" => "rebates#new", :as => "new_rebate"
  get "edit_rebate" => "rebates#edit", :as => "edit_rebate"
  get "show_rebate" => "rebates#show", :as => "show_rebate"
  post "destroy_rebate" => "rebates#destroy", :as => "destroy_rebate"

  #ESTADOS DE LAS DEPRECIACIONES
  get "index_state" => "states#index", :as => "index_state"
  get "new_state" => "states#new", :as => "new_state"
  get "edit_state" => "states#edit", :as => "edit_state"
  get "show_state" => "states#show", :as => "show_state"
  post "destroy_state" => "states#destroy", :as => "destroy_state"

  #INMUEBLES
  get "index_construction" => "constructions#index", :as => "index_construction"
  get "new_construction" => "constructions#new", :as => "new_construction"
  get "edit_construction" => "constructions#edit", :as => "edit_construction"
  get "show_construction" => "constructions#show", :as => "show_construction"
  get "search_construction" => "constructions#search", :as => "search_construction"
  get "close_construction" => "constructions#close", :as => "close_construction"
  get "coordenadas_construction" => "constructions#coordenadas", :as => "coordenadas_construction"
  #get "update_cantons" =>'constructions#update_cantons', :as => 'update_cantons'
  get 'constructions/update_cantons', :as => 'update_cantons'
  get 'constructions/update_parishes', :as => 'update_parishes'
  get 'constructions/update_propietario', :as => 'update_propietario'
  get 'constructions/pers_email_check', :as => 'constructions_pers_email_check'
  get 'constructions/demand_email_check', :as => 'constructions_demand_email_check'
  get "todos_constructions" => "constructions#todos", :as => "todos_constructions"
  post "destroy_construction" => "constructions#destroy", :as => "destroy_construction"

  #post 'index_canton' => 'cantons#index', as: :index

  get '/chats/samplea'

  #AVALUOS
  get "new_avaluo" => "avaluos#new", :as => "new_avaluo"
  get "update_avaluo" => "avaluos#update_avaluo", :as => "update_avaluo"

  get 'avaluos/update_description_val', :as => 'update_description_val'
  get 'avaluos/update_state_val', :as => 'update_state_val'
  get 'avaluos/update_tabla_total', :as => 'update_tabla_total'
  post "aval_update" => "avaluos#update", :as => "aval_update"

  #IMAGENES
  get "index_images" => "images#index", :as => "index_images"
  post "destroy_image" => "images#destroy", :as => "destroy_image"

  #REUNIONES DE INMUEBLES
  get "index_meeting" => "meetings#index", :as => "index_meeting"
  get "new_meeting" => "meetings#new", :as => "new_meeting"
  get "edit_meeting" => "meetings#edit", :as => "edit_meeting"
  post "destroy_meeting" => "meetings#destroy", :as => "destroy_meeting"

  #AGENDA DE CORREDORES
  get "index_diary" => "diaries#index", :as => "index_diary"
  get "new_diary" => "diaries#new", :as => "new_diary"
  get "edit_diary" => "diaries#edit", :as => "edit_diary"
  post "destroy_diary" => "diaries#destroy", :as => "destroy_diary"

  #HONORARIOS DE CORREDORES POR CORRETAJE DE INMUEBLES
  get "index_honorary" => "honoraries#index", :as => "index_honorary"
  get "new_honorary" => "honoraries#new", :as => "new_honorary"
  get "edit_honorary" => "honoraries#edit", :as => "edit_honorary"
  get "show_honorary" => "honoraries#show", :as => "show_honorary"
  get "todos_honorary" => "honoraries#todos", :as => "todos_honorary"
  post "destroy_honorary" => "honoraries#destroy", :as => "destroy_honorary"
  post "reporte_honorary" => "honoraries#reporte_honorary", :as => "reporte_honorary"


  #CUOTAS MENSUALES QUE APORTAN LOS CORREDORES PARA GASTOS DE LA ASOCIACION
  get "index_amount" => "amounts#index", :as => "index_amount"
  get "new_amount" => "amounts#new", :as => "new_amount"
  get "edit_amount" => "amounts#edit", :as => "edit_amount"
  get "show_amount" => "amounts#show", :as => "show_amount"
  post "destroy_amount" => "amounts#destroy", :as => "destroy_amount"

  get "list_detalle" => "personas_roles_usuarios#nombres", :as => "list_detalle"

  #root :to => "usuarios#new"
  #resources :application



#  get "roles/edit"
#  get "roles/show"
#  get "roles/destroy"
    
#  resources :usuarios
  resources :users
  resources :sessions
  resources :personas
  resources :roles
  resources :principal
  resources :properties
  resources :operations
  resources :channels
  resources :provinces
  resources :personas_roles_usuarios
  resources :cantons
  resources :parishes
  resources :pieces
  resources :prices
  resources :parameters
  resources :descriptions
  resources :parameters_descriptions
  resources :rebates
  resources :states
  resources :constructions
  resources :avaluos
  resources :constructions_prices
  resources :areas
  resources :images
  resources :meetings
  resources :diaries
  resources :honoraries
  resources :amounts
  resources :password_resets
  
  
match ':controller(/:action(/:id))(.:format)'
#match '/index' => 'principal#index'
#match '/index' => 'principal#index', :as => 'index'
#  match '/roles/:id', :to => 'principal#index', :as => :role
  match '/roles/:id', :to => 'roles#show', :as => :role
  #match '/cantons/:province_id', :to => 'cantons#index', :as => :canton
#  match ':controller(/:action(/:id))(.:format)'

end
