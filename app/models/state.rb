class State < ActiveRecord::Base
  attr_accessible :met_val_descrip, :met_val_unit, :rebate_id
  belongs_to :rebate

  has_many :constructions_states#, :dependent => :delete_all
  has_many :constructions, :through => :constructions_states

  validates :met_val_unit,
            :presence => {:message => "Debe ingresar un Valor"},
            :format => { :with => /^(\$)?(\d+)(\.|,)?\d{0,2}?$/, :message=>"El valor debe tener entre 1 y 2 decimales" }

  validate :blanco
  def blanco
    self.met_val_descrip = self.met_val_descrip.gsub(/\s+/, " ").strip
#    self.param_val_unit = self.param_val_unit.gsub(/\s+/, " ").strip
  end

  #has_and_belongs_to_many :constructions, :join_table => :constructions_states
end
