# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090301214347) do

  create_table "appointees", :force => true do |t|
    t.integer  "person_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "data_source_id"
  end

  add_index "appointees", ["data_source_id"], :name => "index_appointees_on_data_source_id"
  add_index "appointees", ["person_id"], :name => "index_appointees_on_person_id"

  create_table "appointments", :force => true do |t|
    t.integer  "appointee_id"
    t.string   "title"
    t.string   "organisation_name"
    t.integer  "organisation_id"
    t.text     "acoba_advice"
    t.date     "date_tendered"
    t.date     "date_taken_up"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appointments", ["appointee_id"], :name => "index_appointments_on_appointee_id"

  create_table "data_sources", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "organisation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_sources", ["organisation_id"], :name => "index_data_sources_on_organisation_id"

  create_table "former_roles", :force => true do |t|
    t.integer  "appointee_id"
    t.integer  "department_id"
    t.string   "title"
    t.string   "department_name"
    t.date     "leaving_service_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "former_roles", ["appointee_id"], :name => "index_former_roles_on_appointee_id"
  add_index "former_roles", ["department_id"], :name => "index_former_roles_on_department_id"

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "wikipedia_url"
    t.string   "spinwatch_url"
    t.string   "companieshouse_url"
    t.integer  "company_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "wikipedia_url"
    t.string   "spinwatch_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_name_and_sluggable_type_and_scope_and_sequence", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

end
