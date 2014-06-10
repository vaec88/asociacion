class PersonasConstructionsRole < ActiveRecord::Base
  self.primary_key = "id"
  attr_accessible :persona_id, :construction_id, :role_id
  belongs_to :persona
  belongs_to :construction
  belongs_to :role
end
