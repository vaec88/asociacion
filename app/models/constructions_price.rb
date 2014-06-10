class ConstructionsPrice < ActiveRecord::Base
  self.primary_key = "id"
  attr_accessible :construction_id, :price_id, :det_area, :det_val_unit, :det_val_tot
  belongs_to :construction
  belongs_to :price
end
