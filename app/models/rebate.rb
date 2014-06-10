class Rebate < ActiveRecord::Base
  attr_accessible :met_nombre, :met_nivel
  has_many :states, :dependent => :destroy

  validate :blanco
  def blanco
    self.met_nombre = self.met_nombre.gsub(/\s+/, " ").strip
#    self.param_val_unit = self.param_val_unit.gsub(/\s+/, " ").strip
  end
end
