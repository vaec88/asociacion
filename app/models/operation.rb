class Operation < ActiveRecord::Base
  attr_accessible :oper_nombre
  has_many :constructions#, :dependent => :destroy
  validate :blanco
  def blanco
    self.oper_nombre = self.oper_nombre.gsub(/\s+/, " ").strip
  end
end
