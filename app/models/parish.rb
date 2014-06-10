class Parish < ActiveRecord::Base
  attr_accessible :parr_nombre, :canton_id
  belongs_to :canton
  has_many :constructions#, :dependent => :destroy
  validate :blanco
  def blanco
    self.parr_nombre = self.parr_nombre.gsub(/\s+/, " ").strip
  end
end
