class PersonasRolesUser < ActiveRecord::Base
#  self.primary_key = "id"
  attr_accessible :persona_id, :role_id, :user_id
  belongs_to :persona
  belongs_to :role
  belongs_to :user
end
