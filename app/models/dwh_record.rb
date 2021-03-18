class DwhRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :"dwh_#{Rails.env}"
end
