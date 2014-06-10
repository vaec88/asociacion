class Meeting < ActiveRecord::Base
  attr_accessible :reu_actores, :reu_detalle, :reu_fecha_hora, :reu_estado, :construction_id
  belongs_to :construction

  validate :blanco
  def blanco
    self.reu_actores = self.reu_actores.gsub(/\s+/, " ").strip
    self.reu_detalle = self.reu_detalle.gsub(/\s+/, " ").strip
  end
end
