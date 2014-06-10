class Solicitude < ActiveRecord::Base
  attr_accessible :sol_nombre, :sol_apellido, :sol_email, :sol_msg, :sol_fecha, :construction_id
  belongs_to :construction

  validates :sol_nombre,
            :presence => {:message => "Debe ingresar los Nombres"}
  
  validates :sol_apellido,
            :presence => {:message => "Debe ingresar los Apellidos"}

  validates :sol_email,
            :presence => {:message => "Debe ingresar un Correo Electronico"},
            :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message=>"Correo Electronico no valido" }
          
  validates :sol_msg,
            :presence => {:message => "Debe ingresar un Mensaje"},
            :length => {:minimum => 20, :maximum => 240, :message=>"Mensaje de minimo 20 caracteres y maximo 240"}

  validate :blanco
  def blanco
    self.sol_nombre = self.sol_nombre.gsub(/\s+/, " ").strip
    self.sol_apellido = self.sol_apellido.gsub(/\s+/, " ").strip
    self.sol_msg = self.sol_msg.gsub(/\s+/, " ").strip
  end
end
