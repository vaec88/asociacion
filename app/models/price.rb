class Price < ActiveRecord::Base
  attr_accessible :aval_descrip
  has_many :constructions_prices#, :dependent => :delete_all
  has_many :constructions, :through => :constructions_prices

#  validates :aval_descrip,
#            :presence => {:message => "ATENCION: Faltan datos por ingresar"},
#            :uniqueness => {:case_sensitive => false, :message => "#{self.aval_descrip} ya existe, por favor ingrese otro nombre"}

  validate :blanco
  def blanco
    self.aval_descrip = self.aval_descrip.gsub(/\s+/, " ").strip
  end
  
  #has_many :areas, :class_name=>"Area"#, :foreign_key => "price_id"#, :dependent => :delete_all
  #has_many :constructions, :through => :areas
end
