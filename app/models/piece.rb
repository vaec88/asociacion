class Piece < ActiveRecord::Base
  attr_accessible :part_nombre
  has_many :constructions_pieces, :dependent => :delete_all
  has_many :constructions, :through => :constructions_pieces

  validate :blanco
  def blanco
    self.part_nombre = self.part_nombre.gsub(/\s+/, " ").strip
  end
end
