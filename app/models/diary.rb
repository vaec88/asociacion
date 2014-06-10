class Diary < ActiveRecord::Base
  attr_accessible :age_actividad, :age_fecha, :age_hora, :age_direccion, :user_id
  belongs_to :user
  validate :blanco
  def blanco
    self.age_actividad = self.age_actividad.gsub(/\s+/, " ").strip
    self.age_direccion = self.age_direccion.gsub(/\s+/, " ").strip
  end
end
