class Persona < ActiveRecord::Base
  attr_accessible :pers_cedula, :pers_apellido, :pers_nombre, :pers_direccion, :pers_telefono1, :pers_telefono2, :pers_email, :pers_estado

  #has_and_belongs_to_many :roles, :join_table => :personas_roles_usuarios
  #has_and_belongs_to_many :usuarios, :join_table => :personas_roles_usuarios

  has_many :personas_roles_users#, :dependent => :delete_all
  has_many :roles, :through => :personas_roles_users

  has_many :personas_roles_users#, :dependent => :delete_all
  has_many :users, :through => :personas_roles_users

  has_many :personas_constructions_roles#, :dependent => :delete_all
  has_many :constructions, :through => :personas_constructions_roles

  has_many :personas_constructions_roles#, :dependent => :delete_all
  has_many :roles, :through => :personas_constructions_roles

  validates :pers_cedula,
            :presence => {:message => "Debe ingresar un Numero de Cedula"},
            :length => {:is => 10, :message=>"El Numero de Cedula debe tener 10 digitos"},
            :uniqueness => {:message => "El Numero de Cedula ya existe, por favor ingrese uno diferente"}

  validates :pers_apellido,
            :presence => {:message => "Debe ingresar los Apellidos"}

  validates :pers_nombre,
            :presence => {:message => "Debe ingresar los Nombres"}

  validates :pers_direccion,
            :presence => {:message => "Debe ingresar una Direccion"}

  validates :pers_telefono2,
            :presence => {:message => "Debe ingresar un Numero de Celular"}

  validates :pers_email,
            :presence => {:message => "Debe ingresar un Correo Electronico"},
            :uniqueness => {:case_sensitive => false, :message => "El Correo Electronico ya existe, por favor ingrese uno diferente"},
            :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message=>"Correo Electronico no valido" }


  validate :blanco
  def blanco
    self.pers_cedula = self.pers_cedula.gsub(/\s+/, " ").strip
    self.pers_apellido = self.pers_apellido.gsub(/\s+/, " ").strip
    self.pers_nombre = self.pers_nombre.gsub(/\s+/, " ").strip
    self.pers_direccion = self.pers_direccion.gsub(/\s+/, " ").strip
    self.pers_telefono1 = self.pers_telefono1.gsub(/\s+/, " ").strip
    self.pers_telefono2 = self.pers_telefono2.gsub(/\s+/, " ").strip
    self.pers_email = self.pers_email.gsub(/\s+/, " ").strip
  end

  validate :cedula
  def cedula
    #var cedula = obj_cedula.value;
    cedula = self.pers_cedula.to_s
    #cedula = "0704211778"
    array = []
    i = 0
    cedula.each_char do |c|
      array[i] = c.to_i
      i+=1
    end
    cedula = array
    #cedula = [0,7,0,4,2,1,1,7,7,0]
    cedula_length = cedula.length
    sumando = 0
    total=0
    decena_superior = 0
    digito10 = cedula[9]
    digito10_cal = 0
    if (cedula_length==10)
      for i in 0..8
        sumando=(cedula[i]).to_i
        if (i%2==0)
          sumando=(cedula[i]*2).to_i
          if (sumando>9)
            sumando=(sumando-9).to_i
          end
        end
        total=(total+sumando).to_i
      end
      decena_superior = (((total/10).to_i+1)*10)
      digito10_cal = (decena_superior-total)
      if ((digito10_cal==10 && digito10==0) or (digito10 == digito10_cal))
        #errors.add(:pers_cedula, 'El numero de cedula es correcto')
      else
        if (digito10_cal==10)
          digito10_cal = 0
        end
        errors.add(:pers_cedula, 'Numero de Cedula no valido')
      end
    else
    end
  end
end