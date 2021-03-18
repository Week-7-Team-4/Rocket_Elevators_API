require 'faker'
require 'csv'

class SeedPg

def self.init()
  pp "**INITss**" 

  40.times do
     intervention_create(
      Faker::Number.between(from: 1, to: 200),
      Faker::Number.between(from: 1, to: 200),
      Faker::Number.between(from: 1, to: 200),
      Faker::Number.between(from: 1, to: 200),
      Faker::Number.between(from: 1, to: 200),
      Faker::Date.between(from: '2019-02-23', to: '2020-2-25'),
      Faker::Date.between(from: '2020-02-25', to: '2021-3-15'),
      ['Success', 'Failure', 'Incomplete'].sample,
      "Nothing to report",
      ['Pending', 'InProgress', 'Interrupted' , 'Resumed', 'Complete'].sample
    )
  end

end
# Definitions
def self.intervention_create(employee_id, building_id, battery_id, column_id, elevator_id, start_interv, stop_interv, result, reports, status)
  @intervention = FactIntervention.new({
    employee_id: employee_id,
    building_id: building_id,
    battery_id: battery_id,
    column_id: column_id,
    elevator_id: elevator_id,
    start_interv: start_interv,
    stop_interv: stop_interv,
    result: result,
    reports: reports,
    status: status
  })
  @intervention.save!
end

end