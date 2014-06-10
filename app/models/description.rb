class Description < ActiveRecord::Base
  attr_accessible :param_val_descrip, :param_val_unit
  has_many :parameters_descriptions, :dependent => :delete_all
  has_many :parameters, :through => :parameters_descriptions

  has_many :constructions_parameters

  validates :param_val_unit,
            :presence => {:message => "Debe ingresar un Valor"},
            :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/, :message=>"El valor debe tener entre 1 y 2 decimales" }

  validate :blanco
  def blanco
    self.param_val_descrip = self.param_val_descrip.gsub(/\s+/, " ").strip
#    self.param_val_unit = self.param_val_unit.gsub(/\s+/, " ").strip
  end
end