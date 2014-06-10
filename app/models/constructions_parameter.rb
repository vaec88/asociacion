class ConstructionsParameter < ActiveRecord::Base
  self.primary_key = "id"
  attr_accessible :construction_id, :parameter_id, :description_id
  belongs_to :construction
  belongs_to :parameter
  belongs_to :description
end
