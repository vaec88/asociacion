class Property < ActiveRecord::Base
  attr_accessible :propd_nombre
  has_many :constructions#, :dependent => :destroy

  validate :blanco
  def blanco
    self.propd_nombre = self.propd_nombre.gsub(/\s+/, " ").strip
  end
end
