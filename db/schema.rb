# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_11_193017) do

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type_address"
    t.string "status"
    t.string "entity"
    t.string "number_street"
    t.string "suite_apt"
    t.string "city"
    t.string "postal_code"
    t.string "country"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "building_id"
    t.bigint "customer_id"
    t.string "latitude"
    t.string "longitude"
    t.index ["building_id"], name: "index_addresses_on_building_id"
    t.index ["customer_id"], name: "index_addresses_on_customer_id"
  end

  create_table "batteries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type_building"
    t.string "status"
    t.date "date_commissioning"
    t.date "date_last_inspection"
    t.string "certificate_operations"
    t.string "information"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "building_id"
    t.bigint "employee_id"
    t.index ["building_id"], name: "index_batteries_on_building_id"
    t.index ["employee_id"], name: "index_batteries_on_employee_id"
  end

  create_table "building_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "info_key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "building_id"
    t.index ["building_id"], name: "index_building_details_on_building_id"
  end

  create_table "buildings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "adm_contact_full_name"
    t.string "adm_contact_email"
    t.string "adm_contact_phone"
    t.string "tech_contact_full_name"
    t.string "tech_contact_email"
    t.string "tech_contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id"
    t.bigint "address_id"
    t.index ["address_id"], name: "index_buildings_on_address_id"
    t.index ["customer_id"], name: "index_buildings_on_customer_id"
  end

  create_table "columns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type_building"
    t.integer "number_floors_served"
    t.string "status"
    t.string "information"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "battery_id"
    t.index ["battery_id"], name: "index_columns_on_battery_id"
  end

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date_create"
    t.string "company_name"
    t.string "cpy_contact_full_name"
    t.string "cpy_contact_phone"
    t.string "cpy_contact_email"
    t.string "cpy_description"
    t.string "tech_authority_service_full_name"
    t.string "tech_authority_service_phone"
    t.string "tech_manager_service_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "address_id"
    t.index ["address_id"], name: "index_customers_on_address_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "elevators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "serial_number"
    t.string "model"
    t.string "type_building"
    t.string "status"
    t.date "date_commissioning"
    t.date "date_last_inspection"
    t.string "certificate_inspection"
    t.string "information"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "column_id"
    t.index ["column_id"], name: "index_elevators_on_column_id"
  end

  create_table "employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "function"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "leads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.string "company_name"
    t.string "project_name"
    t.string "department"
    t.string "project_description"
    t.text "message"
    t.binary "file_attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filename"
    t.bigint "customer_id"
    t.index ["customer_id"], name: "index_leads_on_customer_id"
  end

  create_table "quotes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "number_of_apartments"
    t.integer "number_of_floors"
    t.integer "number_of_basements"
    t.integer "number_of_companies"
    t.integer "number_of_corporations"
    t.integer "number_of_parking"
    t.integer "number_of_elevators"
    t.integer "maximum_occupancy"
    t.integer "business_hours"
    t.integer "elevator_amount"
    t.string "product_line"
    t.string "quotes_name"
    t.string "quotes_email"
    t.string "quotes_company_name"
    t.string "install_fees"
    t.string "total_price"
    t.string "unit_price"
    t.string "building_type"
    t.string "final_price"
    t.timestamp "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "buildings"
  add_foreign_key "addresses", "customers"
  add_foreign_key "batteries", "buildings"
  add_foreign_key "batteries", "employees"
  add_foreign_key "building_details", "buildings"
  add_foreign_key "buildings", "addresses"
  add_foreign_key "buildings", "customers"
  add_foreign_key "columns", "batteries"
  add_foreign_key "customers", "addresses"
  add_foreign_key "customers", "users"
  add_foreign_key "elevators", "columns"
  add_foreign_key "employees", "users"
  add_foreign_key "leads", "customers"
end
