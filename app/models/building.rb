class Building < ApplicationRecord
    belongs_to :customer
    has_many :batteries
    has_one :building_detail
    has_one :address
    has_one :employee
end
