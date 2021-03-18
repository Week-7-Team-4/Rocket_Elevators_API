require 'faker'
# "first_name","last_name","company_name","address","city","county","state","zip","phone1","phone2","email","web"
# , :encoding => 'ISO-8859-1'
require 'csv'
# ta = ["Billing", "Shipping", "Home", "Business"]
# to check status of address
# status = ["Online", "Offline", "Online", "Online"]
# id,address_type,status,entity,adress,appartment,city,postal_code,country,notes,created_at,updated_at
#Initialization
def init() 
  puts "init 2"
  address_create()
  employee_create("Nicolas", "Genest", "CEO", 'roc-kets', "nicolas.genest@codeboxx.biz")
  employee_create("Nadya", "Fortier", "Director", "roc-kets", "nadya.fortier@codeboxx.biz")
  employee_create("Martin", "chantal", "Director Assistant", "roc-kets", "martin.chantal@codeboxx.biz")
  employee_create("Mathieu", "Houde", "Captain", "roc-kets", "mathieu.houde@codeboxx.biz")
  employee_create("David", "Boutin", "Engineer", "roc-kets", "david.boutin@codeboxx.biz")
  employee_create("Mathieu", "Lortie", "Engineer", "roc-kets", "mathieu.lortiet@codeboxx.biz")
  employee_create("Thomas", "Carrier", "Engineer", "roc-kets", "thomas.carriert@codeboxx.biz")
  employee_create("Admin1", "Admin1", "Admin1", "roc-kets", "admin1@admin1.com")
  employee_create("Admin", "Admin", "Admin", "roc-kets", "admin@admin.com")
  25.times do 
    customer_create(
      Faker::Company.name,
      Faker::Name.name,
      Faker::PhoneNumber.cell_phone,
      Faker::Internet.email,
      "Description",
      Faker::Name.name,
      Faker::PhoneNumber.cell_phone,
      Faker::Internet.email
    )  
  end
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
    50.times do
      pl = ["Standard", "Premium", "Excelium"]
      bt = ["Residential", "Commercial", "Corporate", "Hybrid"]
  Quote.create(
              install_fees: Faker::Number.between(from: 500, to: 2000),
              total_price: Faker::Number.between(from: 50000, to: 200000),
              product_line: (pl.sample),
              number_of_apartments: Faker::Number.between(from: 50, to: 200),
              number_of_floors: Faker::Number.between(from: 10, to: 70),
              number_of_basements: Faker::Number.between(from: 1, to: 10),
              number_of_corporations: Faker::Number.between(from: 1, to: 100),
              elevator_amount: Faker::Number.between(from: 1, to: 100),
              quotes_name: Faker::Name.name,
              quotes_email: Faker::Internet.email,
              quotes_company_name: Faker::Company.name,
              building_type: (bt.sample),
              final_price: Faker::Number.between(from: 50000, to: 800000),
              number_of_companies: Faker::Number.between(from: 1, to: 5),
              number_of_parking: Faker::Number.between(from: 50, to: 200),
              maximum_occupancy: Faker::Number.between(from: 50, to: 200),
              business_hours: Faker::Number.between(from: 0, to: 24),
              number_of_elevators: Faker::Number.between(from: 1, to: 15),
              unit_price: Faker::Number.between(from: 11000, to: 15000),
              # updated_at: dateCreationUpdate,
              created_at:Faker::Date.between(from: '2018-02-23', to: '2021-2-25')
      )
  end
end
# Definitions
def intervention_create(employee_id, building_id, battery_id, column_id, elevator_id, start_interv, stop_interv, result, reports, status)
  @intervention = Intervention.new({
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
def user_create(email, password, password_confirmation, admin)
  @user = User.new({
    email: email, 
    password: password, 
    password_confirmation: password_confirmation, 
    admin: admin})
  @user.save!
  return @user
end
def employee_create(first_name, last_name, function, phone, email)
  @user = user_create(email, 123456, 123456, true)
  @employee = Employee.create({
    first_name: first_name, 
    last_name: last_name, 
    function: function, 
    phone: phone, 
    email: email, 
    user: @user})
  @employee.save!
end
def customer_create(company_name, cpy_contact_full_name, cpy_contact_phone, cpy_contact_email, cpy_description, tech_authority_service_full_name,
  tech_authority_service_phone, tech_manager_service_email)
  @address = find_random_address('Customer')
  @user = user_create(cpy_contact_email, 123456, 123456, false)
  @customer = Customer.create({
    date_create: Faker::Date.between(from: '2018-02-27', to: '2021-02-27'),
    company_name: company_name, 
    cpy_contact_full_name: cpy_contact_full_name, 
    cpy_contact_phone: cpy_contact_phone, 
    cpy_contact_email: cpy_contact_email, 
    cpy_description: cpy_description, 
    tech_authority_service_full_name: tech_authority_service_full_name, 
    tech_authority_service_phone: tech_authority_service_phone, 
    tech_manager_service_email: tech_manager_service_email, 
    user_id: @user.id,
    address_id: @address.id,
    user: @user,
    address: @address})
  @customer.save!
  rand(1..3).times do 
    building_create(
      cpy_contact_full_name,
      cpy_contact_email,
      cpy_contact_phone,
      tech_authority_service_full_name,
      tech_manager_service_email, 
      tech_authority_service_phone,
      @customer)
  end
end 
def building_create(adm_contact_full_name, adm_contact_email, adm_contact_phone, tech_contact_full_name, tech_contact_email, tech_contact_phone, customer)
  @address = find_random_address('Building')
  @building = Building.new({
    adm_contact_full_name: adm_contact_full_name, 
    adm_contact_email: adm_contact_email, 
    adm_contact_phone: adm_contact_phone, 
    tech_contact_full_name: tech_contact_full_name, 
    tech_contact_email: tech_contact_email, 
    tech_contact_phone: tech_contact_phone, 
    customer_id: customer.id,
    address_id: @address.id,
    customer: customer,
    address: @address})
  @building.save!
  battery_create(
    ["Residential", "Commercial", "Corporate", "Hybrid"].sample,
    ["Online", "Online", "Online", "Online", "Offline"].sample,
    Faker::Date.between(from: '2018-02-27', to: '2021-02-27'),
    Faker::Date.between(from: '2020-02-27', to: '2021-02-27'),
    "Certificate example",
    Faker::Quote.robin,
    Faker::Quote.jack_handey,
    @building)
  building_detail_create(
    "info_key example",
    "value example",
    @building)
end
def address_create()
  require 'csv'
  ta = ["Billing", "Shipping", "Home", "Business"]
  status = ["Online", "Offline", "Online", "Online"]
  entity = ["Building", "Customer"]
  csv_text = File.read(Rails.root.join('lib','address_final.csv'))
  csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
  csv.each do |row|   
      t = Address.new
      t.id = row['id']
      t.type_address = (ta.sample)
      t.status = (status.sample)
      t.entity = (entity.sample)
      t.number_street = row['number_street']
      t.suite_apt = row['suite_apt']
      t.city = row['city']
      t.postal_code = row['postal_code']
      t.country = row['country']
      t.longitude = row['longitude']
      t.latitude = row['latitude']
      t.notes = "1"
      t.created_at = Faker::Date.between(from: '2018-09-23', to: '2021-09-20')
      t.updated_at = Faker::Date.between(from: '2018-09-23', to: '2021-09-25')
      t.save!
    end
end
def find_random_address(entity)
  Address.all.each do 
    @address = Address.order("RAND()").first
    if @address.customer.nil? && @address.building.nil?
      @address.entity = entity
      return @address
    end
  end
end
def building_detail_create(info_key, value, building)
  @building_detail = BuildingDetail.new({
    info_key: info_key,
    value: value,
    building: building})
  @building_detail.save!
end
def battery_create(type_building, status, date_commissioning, date_last_inspection, certificate_operations, information, notes, entity)
  @battery = Battery.new({
    type_building: type_building,
    status: status,
    date_commissioning: date_commissioning,
    date_last_inspection: date_last_inspection,
    certificate_operations: certificate_operations,
    information: information,
    notes: notes,
    building_id: entity.id,
    building: entity})
  @battery.save!
  rand(1..6).times do
    column_create(
      type_building,
      rand(2..50),
      status,
      Faker::Quote.robin,
      Faker::Quote.jack_handey,
      @battery)
  end
end
def column_create(type_building, number_floors_served, status, information, notes, battery)
  @column = Column.new({
    type_building: type_building,
    number_floors_served: number_floors_served,
    status: status,
    information: information,
    notes: notes,
    battery_id: battery.id,
    battery: battery})
  @column.save!
  rand(2..4).times do
    elevator_create(
      Faker::Number.number(digits: 10),
      "Model",
      type_building,
      ["Online", "Online", "Online", "Online", "Offline"].sample,
      Faker::Date.between(from: '2018-02-27', to: '2021-02-27'),
      Faker::Date.between(from: '2020-02-27', to: '2021-02-27'),
      "Certificate example",
      Faker::Quote.robin,
      Faker::Quote.jack_handey,
      @column)
  end
end
def elevator_create(serial_number, model, type_building, status, date_commissioning, date_last_inspection, certificate_inspection, information, notes, column)
  @elevator = Elevator.new({
    serial_number: serial_number,
    model: model,
    type_building: type_building,
    status: status,
    date_commissioning: date_commissioning,
    date_last_inspection: date_last_inspection,
    certificate_inspection: certificate_inspection,
    information: information,
    notes: notes,
    column_id: column.id,
    column: column})
  @elevator.save!
end
50.times do
#   randomizeCustomer = rand(0..9)
#   isCustomer = false

#   if randomizeCustomer <= 2
#     isCustomer = false
#   else
#     isCustomer = true
#   end
#   customers_id = nil
#   if isCustomer
#     customers_id = rand(1..50)
#   end
  
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
      # customer_id: customers_id
  )
end
init()
