class ConstructionsState < ActiveRecord::Base
  self.primary_key = "id"
  attr_accessible :construction_id, :state_id
  belongs_to :construction#, :foreign_key => "construction_id"
  belongs_to :state#, :foreign_key => "state_id"
end
