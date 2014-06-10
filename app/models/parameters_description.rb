class ParametersDescription < ActiveRecord::Base
  attr_accessible :parameter_id, :description_id
  belongs_to :parameter
  belongs_to :description
end
