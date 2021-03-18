class ChartsController < ApplicationController
  before_action :sync
  
  def sync
    pp "inside"
    #   dwh = PG::Connection.new(host: 'codeboxx-postgresql.cq6zrczewpu2.us-east-1.rds.amazonaws.com', port: 5432, dbname: "MaximeAuger_psql", user: "codeboxx", password: "Codeboxx1!")
      dwh = PG::Connection.new(host: 'localhost', port: 5432, dbname: "MaximeAuger_psql", user: "surveytech", password: "2304godZ")

      dwh.exec("TRUNCATE fact_elevators")

      dwh.prepare('to_fact_elevators', 'INSERT INTO fact_elevators (serial_number, date_commissioning, building_id, customer_id, building_city, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)')
      Customer.all.each do |customer|    
      customer.buildings.each do |building|
          building.batteries.each do |battery|
          battery.columns.each do |column|
              column.elevators.each do |elevator|
              # puts building.address.city
              dwh.exec_prepared('to_fact_elevators', [elevator.serial_number, elevator.date_commissioning, battery.building_id, battery.building.customer_id, building.address.city])
              end
          end
          end
      end
      end
      
      dwh.exec("TRUNCATE dim_customers")

      dwh.prepare('to_dim_customers', 'INSERT INTO dim_customers (creation_date, company_name, fn_cpy_main_ct, email_cpy_main_ct, nb_elevators, customer_city, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)')
      Customer.all.each do |customer|          
      nb_elevators = 0
      customer.buildings.each do |building|
          building.batteries.each do |battery|
          battery.columns.each do |column|
              column.elevators.each do |elevator|
              nb_elevators += 1
              end
          end
          end
      end
      
      dwh.exec_prepared('to_dim_customers', [customer.date_create, customer.company_name, customer.cpy_contact_full_name, customer.cpy_contact_email, nb_elevators, customer.address.city])
      end
  end
end



# if rake task runs twice a day this controller will be useless
