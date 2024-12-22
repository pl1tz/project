# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_12_22_153242) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "about_companies", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banks", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", force: :cascade do |t|
    t.string "image"
    t.boolean "status"
    t.string "main_text"
    t.string "second_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "body_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buyouts", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.text "brand"
    t.text "model"
    t.integer "year"
    t.integer "mileage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "call_requests", force: :cascade do |t|
    t.bigint "car_id"
    t.string "name"
    t.string "phone"
    t.string "preferred_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_catalog_configurations", force: :cascade do |t|
    t.bigint "car_catalog_id", null: false
    t.string "package_group"
    t.string "package_name"
    t.float "volume"
    t.string "transmission"
    t.integer "power"
    t.integer "price"
    t.integer "credit_discount"
    t.integer "trade_in_discount"
    t.integer "recycling_discount"
    t.integer "special_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_catalog_id"], name: "index_car_catalog_configurations_on_car_catalog_id"
  end

  create_table "car_catalog_contents", force: :cascade do |t|
    t.bigint "car_catalog_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_catalog_id"], name: "index_car_catalog_contents_on_car_catalog_id"
  end

  create_table "car_catalog_engines", force: :cascade do |t|
    t.bigint "car_catalog_id", null: false
    t.string "name_engines"
    t.integer "torque"
    t.integer "power"
    t.integer "cylinders"
    t.float "engine_volume"
    t.string "fuel_type"
    t.string "engine_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_catalog_id"], name: "index_car_catalog_engines_on_car_catalog_id"
  end

  create_table "car_catalog_extra_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_catalog_extra_names", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_catalog_extras", force: :cascade do |t|
    t.bigint "car_catalog_configuration_id", null: false
    t.bigint "car_catalog_extra_group_id", null: false
    t.bigint "car_catalog_extra_name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_catalog_configuration_id"], name: "index_car_catalog_extras_on_car_catalog_configuration_id"
    t.index ["car_catalog_extra_group_id"], name: "index_car_catalog_extras_on_car_catalog_extra_group_id"
    t.index ["car_catalog_extra_name_id"], name: "index_car_catalog_extras_on_car_catalog_extra_name_id"
  end

  create_table "car_catalog_images", force: :cascade do |t|
    t.bigint "car_catalog_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_catalog_id"], name: "index_car_catalog_images_on_car_catalog_id"
  end

  create_table "car_catalog_texnos", force: :cascade do |t|
    t.bigint "car_catalog_id", null: false
    t.string "image"
    t.integer "width"
    t.integer "height"
    t.integer "length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_catalog_id"], name: "index_car_catalog_texnos_on_car_catalog_id"
  end

  create_table "car_catalogs", force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.integer "power"
    t.float "acceleration"
    t.float "consumption"
    t.integer "max_speed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_colors", force: :cascade do |t|
    t.bigint "car_catalog_id", null: false
    t.string "background"
    t.string "name"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_catalog_id"], name: "index_car_colors_on_car_catalog_id"
  end

  create_table "cars", force: :cascade do |t|
    t.bigint "model_id", null: false
    t.bigint "brand_id", null: false
    t.integer "year"
    t.decimal "price"
    t.text "description"
    t.string "unique_id"
    t.bigint "color_id", null: false
    t.bigint "body_type_id", null: false
    t.bigint "gearbox_type_id", null: false
    t.bigint "drive_type_id", null: false
    t.bigint "engine_name_type_id", null: false
    t.bigint "engine_power_type_id", null: false
    t.bigint "engine_capacity_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "generation_id", null: false
    t.boolean "online_view_available", default: true
    t.string "complectation_name"
    t.index ["body_type_id"], name: "index_cars_on_body_type_id"
    t.index ["brand_id"], name: "index_cars_on_brand_id"
    t.index ["color_id"], name: "index_cars_on_color_id"
    t.index ["drive_type_id"], name: "index_cars_on_drive_type_id"
    t.index ["engine_capacity_type_id"], name: "index_cars_on_engine_capacity_type_id"
    t.index ["engine_name_type_id"], name: "index_cars_on_engine_name_type_id"
    t.index ["engine_power_type_id"], name: "index_cars_on_engine_power_type_id"
    t.index ["gearbox_type_id"], name: "index_cars_on_gearbox_type_id"
    t.index ["generation_id"], name: "index_cars_on_generation_id"
    t.index ["model_id"], name: "index_cars_on_model_id"
    t.index ["unique_id"], name: "index_cars_on_unique_id", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "phone"
    t.string "mode_operation"
    t.string "auto_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credits", force: :cascade do |t|
    t.integer "car_id"
    t.string "name"
    t.string "phone"
    t.integer "credit_term"
    t.decimal "initial_contribution"
    t.integer "banks_id"
    t.integer "programs_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drive_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "engine_capacity_types", force: :cascade do |t|
    t.float "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "engine_name_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "engine_power_types", force: :cascade do |t|
    t.integer "power"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "engine_types", force: :cascade do |t|
    t.string "name"
    t.integer "engine_power"
    t.decimal "engine_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exchanges", force: :cascade do |t|
    t.integer "car_id"
    t.text "customer_car"
    t.string "name"
    t.string "phone"
    t.integer "credit_term"
    t.decimal "initial_contribution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extra_names", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_extra_names_on_name", unique: true
  end

  create_table "extras", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "extra_name_id"
    t.index ["car_id"], name: "index_extras_on_car_id"
    t.index ["category_id"], name: "index_extras_on_category_id"
    t.index ["extra_name_id"], name: "index_extras_on_extra_name_id"
  end

  create_table "gearbox_types", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "generations", force: :cascade do |t|
    t.bigint "model_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_id"], name: "index_generations_on_model_id"
  end

  create_table "history_cars", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.string "vin"
    t.string "registration_number"
    t.integer "last_mileage"
    t.string "registration_restrictions"
    t.string "registration_restrictions_info"
    t.string "wanted_status"
    t.string "wanted_status_info"
    t.string "pledge_status"
    t.string "pledge_status_info"
    t.integer "previous_owners"
    t.string "accidents_found"
    t.string "accidents_found_info"
    t.string "repair_estimates_found"
    t.string "repair_estimates_found_info"
    t.string "carsharing_usage"
    t.string "carsharing_usage_info"
    t.string "taxi_usage"
    t.string "taxi_usage_info"
    t.string "diagnostics_found"
    t.string "diagnostics_found_info"
    t.string "technical_inspection_found"
    t.string "technical_inspection_found_info"
    t.string "imported"
    t.string "imported_info"
    t.string "insurance_found"
    t.string "insurance_found_info"
    t.string "recall_campaigns_found"
    t.string "recall_campaigns_found_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_history_cars_on_car_id"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_images_on_car_id"
  end

  create_table "installments", force: :cascade do |t|
    t.integer "car_id"
    t.string "name"
    t.string "phone"
    t.integer "credit_term"
    t.decimal "initial_contribution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_models_on_brand_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders_buyouts", force: :cascade do |t|
    t.bigint "buyout_id", null: false
    t.bigint "order_status_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyout_id"], name: "index_orders_buyouts_on_buyout_id"
    t.index ["order_status_id"], name: "index_orders_buyouts_on_order_status_id"
  end

  create_table "orders_call_requests", force: :cascade do |t|
    t.bigint "call_request_id", null: false
    t.bigint "order_status_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_request_id"], name: "index_orders_call_requests_on_call_request_id"
    t.index ["order_status_id"], name: "index_orders_call_requests_on_order_status_id"
  end

  create_table "orders_credits", force: :cascade do |t|
    t.bigint "credit_id", null: false
    t.bigint "order_status_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_id"], name: "index_orders_credits_on_credit_id"
    t.index ["order_status_id"], name: "index_orders_credits_on_order_status_id"
  end

  create_table "orders_exchanges", force: :cascade do |t|
    t.bigint "exchange_id", null: false
    t.bigint "order_status_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exchange_id"], name: "index_orders_exchanges_on_exchange_id"
    t.index ["order_status_id"], name: "index_orders_exchanges_on_order_status_id"
  end

  create_table "orders_installments", force: :cascade do |t|
    t.bigint "installment_id", null: false
    t.bigint "order_status_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["installment_id"], name: "index_orders_installments_on_installment_id"
    t.index ["order_status_id"], name: "index_orders_installments_on_order_status_id"
  end

  create_table "programs", force: :cascade do |t|
    t.integer "bank_id"
    t.string "program_name"
    t.float "interest_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "call_requests", "cars"
  add_foreign_key "car_catalog_configurations", "car_catalogs"
  add_foreign_key "car_catalog_contents", "car_catalogs"
  add_foreign_key "car_catalog_engines", "car_catalogs"
  add_foreign_key "car_catalog_extras", "car_catalog_configurations"
  add_foreign_key "car_catalog_extras", "car_catalog_extra_groups"
  add_foreign_key "car_catalog_extras", "car_catalog_extra_names"
  add_foreign_key "car_catalog_images", "car_catalogs"
  add_foreign_key "car_catalog_texnos", "car_catalogs"
  add_foreign_key "car_colors", "car_catalogs"
  add_foreign_key "cars", "body_types"
  add_foreign_key "cars", "brands"
  add_foreign_key "cars", "colors"
  add_foreign_key "cars", "drive_types"
  add_foreign_key "cars", "engine_capacity_types"
  add_foreign_key "cars", "engine_name_types"
  add_foreign_key "cars", "engine_power_types"
  add_foreign_key "cars", "gearbox_types"
  add_foreign_key "cars", "generations"
  add_foreign_key "cars", "models"
  add_foreign_key "credits", "banks", column: "banks_id"
  add_foreign_key "credits", "cars"
  add_foreign_key "credits", "programs", column: "programs_id"
  add_foreign_key "exchanges", "cars"
  add_foreign_key "extras", "cars"
  add_foreign_key "extras", "categories"
  add_foreign_key "extras", "extra_names"
  add_foreign_key "generations", "models"
  add_foreign_key "history_cars", "cars"
  add_foreign_key "images", "cars"
  add_foreign_key "installments", "cars"
  add_foreign_key "models", "brands"
  add_foreign_key "orders_buyouts", "buyouts"
  add_foreign_key "orders_buyouts", "order_statuses"
  add_foreign_key "orders_call_requests", "call_requests"
  add_foreign_key "orders_call_requests", "order_statuses"
  add_foreign_key "orders_credits", "credits"
  add_foreign_key "orders_credits", "order_statuses"
  add_foreign_key "orders_exchanges", "exchanges"
  add_foreign_key "orders_exchanges", "order_statuses"
  add_foreign_key "orders_installments", "installments"
  add_foreign_key "orders_installments", "order_statuses"
  add_foreign_key "programs", "banks"
end
