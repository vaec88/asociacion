class Honorary < ActiveRecord::Base
  attr_accessible :hon_cantidad, :hon_fecha
  belongs_to :construction
  def self.total_honorarios(construction_id)
    suma_honorarios = 0
    honorarios = Honorary.where(:construction_id=>construction_id)
    honorarios.each do |hon|
      suma_honorarios = suma_honorarios + (hon.hon_cantidad).to_i
    end
    Construction.find(construction_id).update_attributes(inm_val_honor: suma_honorarios)
  end
end
