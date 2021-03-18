require 'pg'
namespace :dbr do

  desc "Import data from Quote Table to Fact Quote Table"
  desc "Import data from Lead Table to Fact Contacts Table"
  desc "Import data from product"
  desc "Import data from customers"

  # ======================================================================
  # need to add a daily update\
  # ======================================================================

  task runall: :environment do
    dwh = PG::Connection.new(host: 'localhost', port: 5432, dbname: "MaximeAuger_psql", user: "surveytech", password: "2304godZ")
    puts "lead table to fact_quote table"
    
    dwh.exec("TRUNCATE fact_quotes")

    dwh.prepare('to_fact_quotes', 'INSERT INTO fact_quotes (quote_id, creation, company_name, email, nb_elevator, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)')
    Quote.all.each do |quotes|
      dwh.exec_prepared('to_fact_quotes', [quotes.id, quotes.created_at, quotes.quotes_company_name, quotes.quotes_email, quotes.elevator_amount])
    end
  
    dwh = PG::Connection.new(host: 'localhost', port: 5432, dbname: "MaximeAuger_psql", user: "surveytech", password: "2304godZ")
    puts "lead table to fact_contact table"
    
    dwh.exec("TRUNCATE fact_contacts")

    dwh.prepare('to_fact_contacts', 'INSERT INTO fact_contacts (contact_id, creation_date, company_name, email, project_name, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)')
    Lead.all.each do |ldcontact|
      dwh.exec_prepared('to_fact_contacts', [ldcontact.id, ldcontact.created_at, ldcontact.company_name, ldcontact.email, ldcontact.project_name])
    end
  

    dwh = PG::Connection.new(host: 'localhost', port: 5432, dbname: "MaximeAuger_psql", user: "surveytech", password: "2304godZ")
    dwh.exec("TRUNCATE fact_elevators")
    dwh.prepare('to_fact_elevators', 'INSERT INTO fact_elevators (serial_number, date_commissioning, building_id, customer_id, building_city, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)')
    Customer.all.each do |customer|    
      customer.buildings.each do |building|
        building.batteries.each do |battery|
          battery.columns.each do |column|
            column.elevators.each do |elevator|
              puts building.address.city
              dwh.exec_prepared('to_fact_elevators', [elevator.serial_number, elevator.date_commissioning, battery.building_id, battery.building.customer_id, building.address.city])
            end
          end
        end
      end
    end
  
    dwh = PG::Connection.new(host: 'localhost', port: 5432, dbname: "MaximeAuger_psql", user: "surveytech", password: "2304godZ")
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
      pp nb_elevators
    end
  end

  desc "Import data intervention table to fact_intervention table"
  task factinterv: :environment do
    dwh = PG::Connection.new(host: 'localhost', port: 5432, dbname: "MaximeAuger_psql", user: "surveytech", password: "2304godZ")
    puts "intervention table to fact_intervention table"
    dwh.exec("TRUNCATE fact_interventions")
    dwh.prepare('to_fact_interventions', 'INSERT INTO fact_interventions (employee_id, building_id, battery_id, column_id, elevator_id, start_interv, stop_interv, result, reports, status, created_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)')
    Intervention.all.each do |fact_interventions|
      dwh.exec_prepared('to_fact_interventions', [fact_interventions.employee_id, fact_interventions.building_id, fact_interventions.battery_id, fact_interventions.column_id, fact_interventions.elevator_id, fact_interventions.start_interv, fact_interventions.stop_interv, fact_interventions.result, fact_interventions.reports, fact_interventions.status])
    end
  end
end 

namespace :seed do
  task leads: :environment do
    custom = 1
    50.times do
      randomizeCustomer = rand(0..9)
      isCustomer = false
      if randomizeCustomer <= 5
        isCustomer = false
      else
        isCustomer = true
      end
      customers_id = nil
      if isCustomer
        customers_id = custom
        custom += 1
      end
      
      lead = Lead.create(
          full_name: Faker::Name.name,
          email: Faker::Internet.email,
          phone: Faker::PhoneNumber.phone_number,
          company_name: Faker::Company.unique.name,
          project_name: Faker::Appliance.brand,
          department: Faker::Company.industry,
          project_description: Faker::Lorem.sentences(number: 1, supplemental: true),
          message: Faker::Lorem.paragraphs(number: 1), 
          created_at: Faker::Time.between_dates(from: Date.today - 1, to: Date.today - 1000, period: :all),
          customer_id: customers_id
      )
      puts lead.inspect
      lead.save!
  
      costumers_id = nil
    end
  end
end



