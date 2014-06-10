class User < ActiveRecord::Base
  authenticates_with_sorcery!
  # attr_accessible :title, :body
  attr_accessible :username, :email, :usu_foto, :usu_estado, :usu_matr_prof, :usu_pag_web, :password, :password_confirmation
  #has_many :personas
  #has_and_belongs_to_many :personas
  #has_and_belongs_to_many :roles
  #has_and_belongs_to_many :personas, :join_table => :personas_roles_usuarios
  #has_and_belongs_to_many :roles, :join_table => :personas_roles_usuarios

  has_many :personas_roles_users
  has_many :personas, :through => :personas_roles_users

  has_many :personas_roles_users#, :dependent => :delete_all
  has_many :roles, :through => :personas_roles_users

  has_many :diaries, :dependent => :destroy
  has_many :amounts, :dependent => :destroy

  validates :username,
            :presence => {:message => "Debe ingresar un Nombre de Usuario"},
            :uniqueness => {:case_sensitive => false, :message => "El Nombre de Usuario ya existe, por favor ingrese uno diferente"}

  validates :password,
            :presence => {:message => "Debe ingresar una Contrasenia"},
            :length => {:minimum => 6, :maximum => 16, :message=>"Minimo 6 caracteres y maximo 16"},
            :format => {:with => /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/, :message=>"Incluir mayusculas, minusculas y numeros"},
            :confirmation => {:message => "Las contrasenias no coinciden!"},:on => :create

  validates :usu_matr_prof,
            :presence => {:message => "Debe ingresar una Matricula Profesional"},
            :uniqueness => {:case_sensitive => false, :message => "La Matricula Profesional ya existe, por favor ingrese una diferente"}

  #ADVERTENCIA: AL ACTIVAR LA VALIDACION BLANCO, EDITAR CONTRASENIA NO FUNCIONA.
  #LAS RAZONES DE ESTE BUG AUN SON DESCONOCIDAS, POR LO QUE SE LO CLASIFICA COMO MISTERIO DE LA INFORMATICA.
  validate :blanco
  def blanco
#    self.usu_username = self.usu_username.gsub(/\s+/, " ").strip
#    self.usu_password = self.usu_password.gsub(/\s+/, " ").strip
#    self.usu_matr_prof = self.usu_matr_prof.gsub(/\s+/, " ").strip
#    self.usu_pag_web = self.usu_pag_web.gsub(/\s+/, " ").strip
  end


  has_attached_file :usu_foto,
    :storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    #:dropbox_options => {environment: ENV["RACK_ENV"]},
    #:default_url => "/images/usuarios/perfil.jpg",
    #:path => ":rails_root/public/images/usuarios/:id/:basename_:style.:extension",
    #:url => "/images/usuarios/:id/:basename_:style.:extension",
    :default_url => "https://dl.dropboxusercontent.com/u/246482361/images/usuarios/perfil.JPG",
    :path => "images/usuarios/:id/:basename_:style.:extension",
    :url => "images/usuarios/:id/:basename_:style.:extension",
    :default_style => :small,
    #:path => ':rails_root/public:url',
	    :styles => {
	      :thumb=> "100x100#",
	      :small  => "150x150>" }
	  # Validaciones de Paperclip
	  validates_attachment_size :usu_foto, :less_than => 2.megabytes
	  validates_attachment_content_type :usu_foto, :content_type => ['image/jpeg', 'image/png']
    
#  def self.authenticate(username, password)
#    user = find_by_username(username)
#    if user && user.crypted_password == BCrypt::Engine.hash_secret(password, user.salt)
#      user
#    else
#      nil
#    end
#  end
end
