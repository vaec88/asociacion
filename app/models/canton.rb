class Canton < ActiveRecord::Base
  attr_accessible :cant_nombre, :province_id
  has_many :parishes, :dependent => :destroy
  belongs_to :province
  validate :blanco
  def blanco
    self.cant_nombre = self.cant_nombre.gsub(/\s+/, " ").strip
  end
end
