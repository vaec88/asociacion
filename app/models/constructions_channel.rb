class ConstructionsChannel < ActiveRecord::Base
  self.primary_key = "id"
  attr_accessible :construction_id, :channel_id
  belongs_to :construction
  belongs_to :channel
end