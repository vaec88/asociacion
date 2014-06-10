class Province < ActiveRecord::Base
  attr_accessible :prov_nombre
  has_many :cantons, :dependent => :destroy
  validate :blanco
  def blanco
    self.prov_nombre = self.prov_nombre.gsub(/\s+/, " ").strip
  end
  
  def self.prov_id(id)
    province = find_by_id(id)
    if province
      province
    else
      nil
    end
  end
end
