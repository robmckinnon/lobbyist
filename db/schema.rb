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

ActiveRecord::Schema.define(:version => 20091017160643) do

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
  add_index "appointments", ["organisation_id"], :name => "index_appointments_on_organisation_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "company_number"
    t.text     "address"
    t.string   "url"
    t.string   "wikipedia_url"
    t.string   "company_category"
    t.string   "company_status"
    t.date     "incorporation_date"
    t.string   "country_code",       :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["company_category"], :name => "index_companies_on_company_category"
  add_index "companies", ["company_number"], :name => "index_companies_on_company_number"
  add_index "companies", ["company_status"], :name => "index_companies_on_company_status"
  add_index "companies", ["country_code"], :name => "index_companies_on_country_code"
  add_index "companies", ["name"], :name => "index_companies_on_name"
  add_index "companies", ["url"], :name => "index_companies_on_url"

  create_table "company_classifications", :force => true do |t|
    t.integer  "organisation_id"
    t.integer  "sic_uk_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sic_uk_class_code"
    t.string   "sic_uk_section_code"
    t.integer  "company_id"
  end

  add_index "company_classifications", ["company_id"], :name => "index_company_classifications_on_company_id"
  add_index "company_classifications", ["organisation_id"], :name => "index_company_classifications_on_organisation_id"
  add_index "company_classifications", ["sic_uk_class_code"], :name => "index_company_classifications_on_sic_uk_class_code"
  add_index "company_classifications", ["sic_uk_class_id"], :name => "index_company_classifications_on_sic_uk_class_id"
  add_index "company_classifications", ["sic_uk_section_code"], :name => "index_company_classifications_on_sic_uk_section_code"

  create_table "company_search_results", :force => true do |t|
    t.integer  "company_search_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_search_results", ["company_id"], :name => "index_company_search_results_on_company_id"
  add_index "company_search_results", ["company_search_id"], :name => "index_company_search_results_on_company_search_id"

  create_table "company_searches", :force => true do |t|
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_searches", ["term"], :name => "index_company_searches_on_term"

  create_table "consultancy_clients", :force => true do |t|
    t.string   "name"
    t.text     "name_in_parentheses"
    t.integer  "organisation_id"
    t.integer  "register_entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consultancy_clients", ["name"], :name => "index_consultancy_clients_on_name"
  add_index "consultancy_clients", ["organisation_id"], :name => "index_consultancy_clients_on_organisation_id"
  add_index "consultancy_clients", ["register_entry_id"], :name => "index_consultancy_clients_on_register_entry_id"

  create_table "consultancy_staff_members", :force => true do |t|
    t.string   "name"
    t.integer  "person_id"
    t.integer  "register_entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consultancy_staff_members", ["person_id"], :name => "index_consultancy_staff_members_on_person_id"
  add_index "consultancy_staff_members", ["register_entry_id"], :name => "index_consultancy_staff_members_on_register_entry_id"

  create_table "data_sources", :force => true do |t|
    t.string   "name"
    t.string   "long_name"
    t.string   "url"
    t.integer  "organisation_id"
    t.date     "period_start"
    t.date     "period_end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "as_at_date"
    t.string   "file"
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

  create_table "government_departments", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lords", :force => true do |t|
    t.integer  "person_id"
    t.string   "publicwhip_id"
    t.string   "house"
    t.string   "forenames"
    t.string   "forenames_full"
    t.string   "surname"
    t.string   "title"
    t.string   "lord_name"
    t.string   "lord_of_name"
    t.string   "lord_of_name_full"
    t.string   "county"
    t.string   "peerage_type"
    t.string   "affiliation"
    t.boolean  "ex_mp"
    t.string   "from_why"
    t.string   "to_why"
    t.integer  "from_year"
    t.date     "from_date"
    t.date     "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lords", ["affiliation"], :name => "index_lords_on_affiliation"
  add_index "lords", ["lord_name"], :name => "index_lords_on_lord_name"
  add_index "lords", ["lord_of_name"], :name => "index_lords_on_lord_of_name"
  add_index "lords", ["lord_of_name_full"], :name => "index_lords_on_lord_of_name_full"
  add_index "lords", ["person_id"], :name => "index_lords_on_person_id"
  add_index "lords", ["publicwhip_id"], :name => "index_lords_on_publicwhip_id"
  add_index "lords", ["title"], :name => "index_lords_on_title"

  create_table "members", :force => true do |t|
    t.integer  "person_id"
    t.string   "publicwhip_id"
    t.string   "house"
    t.string   "title"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "constituency"
    t.string   "party"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "from_why"
    t.string   "to_why"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["party"], :name => "index_members_on_party"
  add_index "members", ["person_id"], :name => "index_members_on_person_id"
  add_index "members", ["publicwhip_id"], :name => "index_members_on_publicwhip_id"

  create_table "members_interests_categories", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members_interests_entries", :force => true do |t|
    t.integer  "member_id"
    t.integer  "data_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members_interests_entries", ["data_source_id"], :name => "index_members_interests_entries_on_data_source_id"
  add_index "members_interests_entries", ["member_id"], :name => "index_members_interests_entries_on_member_id"

  create_table "members_interests_items", :force => true do |t|
    t.integer  "members_interests_category_id"
    t.integer  "members_interests_entry_id"
    t.string   "subcategory"
    t.text     "description"
    t.string   "range_amount_text"
    t.string   "actual_amount_text"
    t.string   "up_to_amount_text"
    t.string   "from_amount_text"
    t.integer  "actual_amount"
    t.integer  "up_to_amount"
    t.integer  "from_amount"
    t.string   "currency_symbol"
    t.string   "registered_date_text"
    t.date     "registered_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members_interests_items", ["members_interests_category_id"], :name => "index_members_interests_items_on_members_interests_category_id"
  add_index "members_interests_items", ["members_interests_entry_id"], :name => "index_members_interests_items_on_members_interests_entry_id"

  create_table "members_organisation_interests", :force => true do |t|
    t.integer  "organisation_id"
    t.integer  "members_interests_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members_organisation_interests", ["members_interests_item_id"], :name => "index_organisation_interests_on_members_interests_item_id"
  add_index "members_organisation_interests", ["organisation_id"], :name => "index_members_organisation_interests_on_organisation_id"

  create_table "monitoring_clients", :force => true do |t|
    t.string   "name"
    t.text     "name_in_parentheses"
    t.integer  "organisation_id"
    t.integer  "register_entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monitoring_clients", ["name"], :name => "index_monitoring_clients_on_name"
  add_index "monitoring_clients", ["organisation_id"], :name => "index_monitoring_clients_on_organisation_id"
  add_index "monitoring_clients", ["register_entry_id"], :name => "index_monitoring_clients_on_register_entry_id"

  create_table "office_contacts", :force => true do |t|
    t.integer  "register_entry_id"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "office_contacts", ["register_entry_id"], :name => "index_office_contacts_on_register_entry_id"

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.string   "alternate_name"
    t.string   "url"
    t.string   "wikipedia_url"
    t.string   "spinwatch_url"
    t.string   "company_number"
    t.string   "registered_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organisations", ["name"], :name => "index_organisations_on_name"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "wikipedia_url"
    t.string   "spinwatch_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publicwhip_id"
  end

  add_index "people", ["name"], :name => "index_people_on_name"
  add_index "people", ["publicwhip_id"], :name => "index_people_on_publicwhip_id"

  create_table "quangos", :force => true do |t|
    t.string   "name"
    t.string   "name_in_brackets"
    t.string   "alternate_name"
    t.string   "acronym"
    t.string   "quango_type"
    t.string   "focus"
    t.string   "url"
    t.string   "source"
    t.boolean  "dormant"
    t.integer  "organisation_id"
    t.integer  "government_department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quangos", ["government_department_id"], :name => "index_quangos_on_government_department_id"
  add_index "quangos", ["name"], :name => "index_quangos_on_name"
  add_index "quangos", ["organisation_id"], :name => "index_quangos_on_organisation_id"
  add_index "quangos", ["quango_type"], :name => "index_quangos_on_quango_type"

  create_table "register_entries", :force => true do |t|
    t.string   "organisation_name"
    t.string   "organisation_url"
    t.integer  "organisation_id"
    t.integer  "data_source_id"
    t.string   "declaration_signed_or_submitted"
    t.text     "offices_outside_the_uk"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "register_entries", ["data_source_id"], :name => "index_register_entries_on_data_source_id"
  add_index "register_entries", ["organisation_id"], :name => "index_register_entries_on_organisation_id"

  create_table "sic_uk_classes", :force => true do |t|
    t.integer "year"
    t.string  "code"
    t.string  "description"
    t.integer "sic_uk_group_id"
    t.integer "sic_uk_division_id"
    t.integer "sic_uk_subsection_id"
    t.integer "sic_uk_section_id"
    t.integer "sic_uk_code"
  end

  add_index "sic_uk_classes", ["sic_uk_code"], :name => "index_sic_uk_classes_on_sic_uk_code"
  add_index "sic_uk_classes", ["sic_uk_division_id"], :name => "index_sic_uk_classes_on_sic_uk_division_id"
  add_index "sic_uk_classes", ["sic_uk_group_id"], :name => "index_sic_uk_classes_on_sic_uk_group_id"
  add_index "sic_uk_classes", ["sic_uk_section_id"], :name => "index_sic_uk_classes_on_sic_uk_section_id"
  add_index "sic_uk_classes", ["sic_uk_subsection_id"], :name => "index_sic_uk_classes_on_sic_uk_subsection_id"

  create_table "sic_uk_divisions", :force => true do |t|
    t.integer "year"
    t.string  "code"
    t.string  "description"
    t.integer "sic_uk_subsection_id"
    t.integer "sic_uk_section_id"
  end

  add_index "sic_uk_divisions", ["sic_uk_section_id"], :name => "index_sic_uk_divisions_on_sic_uk_section_id"
  add_index "sic_uk_divisions", ["sic_uk_subsection_id"], :name => "index_sic_uk_divisions_on_sic_uk_subsection_id"

  create_table "sic_uk_groups", :force => true do |t|
    t.integer "year"
    t.string  "code"
    t.string  "description"
    t.integer "sic_uk_division_id"
    t.integer "sic_uk_subsection_id"
    t.integer "sic_uk_section_id"
  end

  add_index "sic_uk_groups", ["sic_uk_division_id"], :name => "index_sic_uk_groups_on_sic_uk_division_id"
  add_index "sic_uk_groups", ["sic_uk_section_id"], :name => "index_sic_uk_groups_on_sic_uk_section_id"
  add_index "sic_uk_groups", ["sic_uk_subsection_id"], :name => "index_sic_uk_groups_on_sic_uk_subsection_id"

  create_table "sic_uk_sections", :force => true do |t|
    t.integer "year"
    t.string  "code"
    t.string  "description"
  end

  create_table "sic_uk_subclasses", :force => true do |t|
    t.integer "year"
    t.string  "code"
    t.string  "description"
    t.integer "sic_uk_class_id"
    t.integer "sic_uk_group_id"
    t.integer "sic_uk_division_id"
    t.integer "sic_uk_subsection_id"
    t.integer "sic_uk_section_id"
    t.integer "sic_uk_code"
  end

  add_index "sic_uk_subclasses", ["sic_uk_class_id"], :name => "index_sic_uk_subclasses_on_sic_uk_class_id"
  add_index "sic_uk_subclasses", ["sic_uk_code"], :name => "index_sic_uk_subclasses_on_sic_uk_code"
  add_index "sic_uk_subclasses", ["sic_uk_division_id"], :name => "index_sic_uk_subclasses_on_sic_uk_division_id"
  add_index "sic_uk_subclasses", ["sic_uk_group_id"], :name => "index_sic_uk_subclasses_on_sic_uk_group_id"
  add_index "sic_uk_subclasses", ["sic_uk_section_id"], :name => "index_sic_uk_subclasses_on_sic_uk_section_id"
  add_index "sic_uk_subclasses", ["sic_uk_subsection_id"], :name => "index_sic_uk_subclasses_on_sic_uk_subsection_id"

  create_table "sic_uk_subsections", :force => true do |t|
    t.integer "year"
    t.string  "code"
    t.string  "description"
    t.integer "sic_uk_section_id"
  end

  add_index "sic_uk_subsections", ["sic_uk_section_id"], :name => "index_sic_uk_subsections_on_sic_uk_section_id"

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

  create_table "special_advisor_appointing_ministers", :force => true do |t|
    t.string   "title"
    t.integer  "special_advisor_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "special_advisor_appointing_ministers", ["special_advisor_list_id"], :name => "index_appointing_ministers_on_special_advisor_list_id"

  create_table "special_advisor_lists", :force => true do |t|
    t.date     "at_date"
    t.integer  "data_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "special_advisor_lists", ["data_source_id"], :name => "index_special_advisor_lists_on_data_source_id"

  create_table "special_advisors", :force => true do |t|
    t.string   "name"
    t.string   "qualification"
    t.integer  "special_advisor_list_id"
    t.integer  "special_advisor_appointing_minister_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "special_advisors", ["special_advisor_appointing_minister_id"], :name => "index_special_advisors_on_special_advisor_appointing_minister_id"
  add_index "special_advisors", ["special_advisor_list_id"], :name => "index_special_advisors_on_special_advisor_list_id"

end
