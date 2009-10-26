CREATE TABLE `advisor_lobbyists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `special_advisor_id` int(11) DEFAULT NULL,
  `consultancy_staff_member_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_advisor_lobbyists_on_special_advisor_id` (`special_advisor_id`),
  KEY `index_advisor_lobbyists_on_consultancy_staff_member_id` (`consultancy_staff_member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

CREATE TABLE `appointees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `data_source_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_appointees_on_person_id` (`person_id`),
  KEY `index_appointees_on_data_source_id` (`data_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appointee_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `organisation_name` varchar(255) DEFAULT NULL,
  `organisation_id` int(11) DEFAULT NULL,
  `acoba_advice` text,
  `date_tendered` date DEFAULT NULL,
  `date_taken_up` date DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_appointments_on_appointee_id` (`appointee_id`),
  KEY `index_appointments_on_organisation_id` (`organisation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8;

CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `company_number` varchar(255) DEFAULT NULL,
  `address` text,
  `url` varchar(255) DEFAULT NULL,
  `wikipedia_url` varchar(255) DEFAULT NULL,
  `company_category` varchar(255) DEFAULT NULL,
  `company_status` varchar(255) DEFAULT NULL,
  `incorporation_date` date DEFAULT NULL,
  `country_code` varchar(2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_companies_on_company_number` (`company_number`),
  KEY `index_companies_on_name` (`name`),
  KEY `index_companies_on_url` (`url`),
  KEY `index_companies_on_company_category` (`company_category`),
  KEY `index_companies_on_company_status` (`company_status`),
  KEY `index_companies_on_country_code` (`country_code`)
) ENGINE=InnoDB AUTO_INCREMENT=24421 DEFAULT CHARSET=utf8;

CREATE TABLE `company_classifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organisation_id` int(11) DEFAULT NULL,
  `sic_uk_class_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sic_uk_class_code` int(11) DEFAULT NULL,
  `sic_uk_section_code` varchar(255) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_company_classifications_on_organisation_id` (`organisation_id`),
  KEY `index_company_classifications_on_sic_uk_class_id` (`sic_uk_class_id`),
  KEY `index_company_classifications_on_sic_uk_class_code` (`sic_uk_class_code`),
  KEY `index_company_classifications_on_sic_uk_section_code` (`sic_uk_section_code`),
  KEY `index_company_classifications_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15272 DEFAULT CHARSET=utf8;

CREATE TABLE `company_search_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_search_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_company_search_results_on_company_search_id` (`company_search_id`),
  KEY `index_company_search_results_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16810 DEFAULT CHARSET=utf8;

CREATE TABLE `company_searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `term` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_company_searches_on_term` (`term`)
) ENGINE=InnoDB AUTO_INCREMENT=912 DEFAULT CHARSET=utf8;

CREATE TABLE `consultancy_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `name_in_parentheses` text,
  `organisation_id` int(11) DEFAULT NULL,
  `register_entry_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_consultancy_clients_on_organisation_id` (`organisation_id`),
  KEY `index_consultancy_clients_on_register_entry_id` (`register_entry_id`),
  KEY `index_consultancy_clients_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3121 DEFAULT CHARSET=utf8;

CREATE TABLE `consultancy_staff_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `register_entry_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_consultancy_staff_members_on_person_id` (`person_id`),
  KEY `index_consultancy_staff_members_on_register_entry_id` (`register_entry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1607 DEFAULT CHARSET=utf8;

CREATE TABLE `data_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `long_name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `organisation_id` int(11) DEFAULT NULL,
  `period_start` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `as_at_date` date DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_data_sources_on_organisation_id` (`organisation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

CREATE TABLE `former_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appointee_id` int(11) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `department_name` varchar(255) DEFAULT NULL,
  `leaving_service_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_former_roles_on_appointee_id` (`appointee_id`),
  KEY `index_former_roles_on_department_id` (`department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

CREATE TABLE `government_departments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;

CREATE TABLE `lords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `publicwhip_id` varchar(255) DEFAULT NULL,
  `house` varchar(255) DEFAULT NULL,
  `forenames` varchar(255) DEFAULT NULL,
  `forenames_full` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `lord_name` varchar(255) DEFAULT NULL,
  `lord_of_name` varchar(255) DEFAULT NULL,
  `lord_of_name_full` varchar(255) DEFAULT NULL,
  `county` varchar(255) DEFAULT NULL,
  `peerage_type` varchar(255) DEFAULT NULL,
  `affiliation` varchar(255) DEFAULT NULL,
  `ex_mp` tinyint(1) DEFAULT NULL,
  `from_why` varchar(255) DEFAULT NULL,
  `to_why` varchar(255) DEFAULT NULL,
  `from_year` int(11) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_lords_on_person_id` (`person_id`),
  KEY `index_lords_on_publicwhip_id` (`publicwhip_id`),
  KEY `index_lords_on_affiliation` (`affiliation`),
  KEY `index_lords_on_title` (`title`),
  KEY `index_lords_on_lord_name` (`lord_name`),
  KEY `index_lords_on_lord_of_name` (`lord_of_name`),
  KEY `index_lords_on_lord_of_name_full` (`lord_of_name_full`)
) ENGINE=InnoDB AUTO_INCREMENT=972 DEFAULT CHARSET=utf8;

CREATE TABLE `member_offices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `publicwhip_id` varchar(255) DEFAULT NULL,
  `publicwhip_member_id` varchar(255) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_member_offices_on_publicwhip_id` (`publicwhip_id`),
  KEY `index_member_offices_on_publicwhip_member_id` (`publicwhip_member_id`),
  KEY `index_member_offices_on_member_id` (`member_id`),
  KEY `index_member_offices_on_department` (`department`)
) ENGINE=InnoDB AUTO_INCREMENT=4295 DEFAULT CHARSET=utf8;

CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL,
  `publicwhip_id` varchar(255) DEFAULT NULL,
  `house` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `constituency` varchar(255) DEFAULT NULL,
  `party` varchar(255) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `from_why` varchar(255) DEFAULT NULL,
  `to_why` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_members_on_person_id` (`person_id`),
  KEY `index_members_on_publicwhip_id` (`publicwhip_id`),
  KEY `index_members_on_party` (`party`)
) ENGINE=InnoDB AUTO_INCREMENT=4203 DEFAULT CHARSET=utf8;

CREATE TABLE `members_interests_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

CREATE TABLE `members_interests_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `data_source_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_members_interests_entries_on_member_id` (`member_id`),
  KEY `index_members_interests_entries_on_data_source_id` (`data_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1293 DEFAULT CHARSET=utf8;

CREATE TABLE `members_interests_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `members_interests_category_id` int(11) DEFAULT NULL,
  `members_interests_entry_id` int(11) DEFAULT NULL,
  `subcategory` varchar(255) DEFAULT NULL,
  `description` text,
  `range_amount_text` varchar(255) DEFAULT NULL,
  `actual_amount_text` varchar(255) DEFAULT NULL,
  `up_to_amount_text` varchar(255) DEFAULT NULL,
  `from_amount_text` varchar(255) DEFAULT NULL,
  `actual_amount` int(11) DEFAULT NULL,
  `up_to_amount` int(11) DEFAULT NULL,
  `from_amount` int(11) DEFAULT NULL,
  `currency_symbol` varchar(255) DEFAULT NULL,
  `registered_date_text` varchar(255) DEFAULT NULL,
  `registered_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_members_interests_items_on_members_interests_category_id` (`members_interests_category_id`),
  KEY `index_members_interests_items_on_members_interests_entry_id` (`members_interests_entry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4952 DEFAULT CHARSET=utf8;

CREATE TABLE `members_organisation_interests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organisation_id` int(11) DEFAULT NULL,
  `members_interests_item_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_members_organisation_interests_on_organisation_id` (`organisation_id`),
  KEY `index_organisation_interests_on_members_interests_item_id` (`members_interests_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1292 DEFAULT CHARSET=utf8;

CREATE TABLE `monitoring_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `name_in_parentheses` text,
  `organisation_id` int(11) DEFAULT NULL,
  `register_entry_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_monitoring_clients_on_organisation_id` (`organisation_id`),
  KEY `index_monitoring_clients_on_register_entry_id` (`register_entry_id`),
  KEY `index_monitoring_clients_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8;

CREATE TABLE `office_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `register_entry_id` int(11) DEFAULT NULL,
  `details` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_office_contacts_on_register_entry_id` (`register_entry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;

CREATE TABLE `organisations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `alternate_name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `wikipedia_url` varchar(255) DEFAULT NULL,
  `spinwatch_url` varchar(255) DEFAULT NULL,
  `company_number` varchar(255) DEFAULT NULL,
  `registered_name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_organisations_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3895 DEFAULT CHARSET=utf8;

CREATE TABLE `people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `wikipedia_url` varchar(255) DEFAULT NULL,
  `spinwatch_url` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `publicwhip_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_people_on_publicwhip_id` (`publicwhip_id`),
  KEY `index_people_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5566 DEFAULT CHARSET=utf8;

CREATE TABLE `quangos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `name_in_brackets` varchar(255) DEFAULT NULL,
  `alternate_name` varchar(255) DEFAULT NULL,
  `acronym` varchar(255) DEFAULT NULL,
  `quango_type` varchar(255) DEFAULT NULL,
  `focus` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `dormant` tinyint(1) DEFAULT NULL,
  `organisation_id` int(11) DEFAULT NULL,
  `government_department_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_quangos_on_quango_type` (`quango_type`),
  KEY `index_quangos_on_name` (`name`),
  KEY `index_quangos_on_organisation_id` (`organisation_id`),
  KEY `index_quangos_on_government_department_id` (`government_department_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1397 DEFAULT CHARSET=utf8;

CREATE TABLE `register_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organisation_name` varchar(255) DEFAULT NULL,
  `organisation_url` varchar(255) DEFAULT NULL,
  `organisation_id` int(11) DEFAULT NULL,
  `data_source_id` int(11) DEFAULT NULL,
  `declaration_signed_or_submitted` varchar(255) DEFAULT NULL,
  `offices_outside_the_uk` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_register_entries_on_data_source_id` (`data_source_id`),
  KEY `index_register_entries_on_organisation_id` (`organisation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sic_uk_classes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sic_uk_group_id` int(11) DEFAULT NULL,
  `sic_uk_division_id` int(11) DEFAULT NULL,
  `sic_uk_subsection_id` int(11) DEFAULT NULL,
  `sic_uk_section_id` int(11) DEFAULT NULL,
  `sic_uk_code` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sic_uk_classes_on_sic_uk_group_id` (`sic_uk_group_id`),
  KEY `index_sic_uk_classes_on_sic_uk_division_id` (`sic_uk_division_id`),
  KEY `index_sic_uk_classes_on_sic_uk_subsection_id` (`sic_uk_subsection_id`),
  KEY `index_sic_uk_classes_on_sic_uk_section_id` (`sic_uk_section_id`),
  KEY `index_sic_uk_classes_on_sic_uk_code` (`sic_uk_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1130 DEFAULT CHARSET=utf8;

CREATE TABLE `sic_uk_divisions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sic_uk_subsection_id` int(11) DEFAULT NULL,
  `sic_uk_section_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sic_uk_divisions_on_sic_uk_subsection_id` (`sic_uk_subsection_id`),
  KEY `index_sic_uk_divisions_on_sic_uk_section_id` (`sic_uk_section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8;

CREATE TABLE `sic_uk_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sic_uk_division_id` int(11) DEFAULT NULL,
  `sic_uk_subsection_id` int(11) DEFAULT NULL,
  `sic_uk_section_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sic_uk_groups_on_sic_uk_division_id` (`sic_uk_division_id`),
  KEY `index_sic_uk_groups_on_sic_uk_subsection_id` (`sic_uk_subsection_id`),
  KEY `index_sic_uk_groups_on_sic_uk_section_id` (`sic_uk_section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=497 DEFAULT CHARSET=utf8;

CREATE TABLE `sic_uk_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

CREATE TABLE `sic_uk_subclasses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sic_uk_class_id` int(11) DEFAULT NULL,
  `sic_uk_group_id` int(11) DEFAULT NULL,
  `sic_uk_division_id` int(11) DEFAULT NULL,
  `sic_uk_subsection_id` int(11) DEFAULT NULL,
  `sic_uk_section_id` int(11) DEFAULT NULL,
  `sic_uk_code` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sic_uk_subclasses_on_sic_uk_class_id` (`sic_uk_class_id`),
  KEY `index_sic_uk_subclasses_on_sic_uk_group_id` (`sic_uk_group_id`),
  KEY `index_sic_uk_subclasses_on_sic_uk_division_id` (`sic_uk_division_id`),
  KEY `index_sic_uk_subclasses_on_sic_uk_subsection_id` (`sic_uk_subsection_id`),
  KEY `index_sic_uk_subclasses_on_sic_uk_section_id` (`sic_uk_section_id`),
  KEY `index_sic_uk_subclasses_on_sic_uk_code` (`sic_uk_code`)
) ENGINE=InnoDB AUTO_INCREMENT=477 DEFAULT CHARSET=utf8;

CREATE TABLE `sic_uk_subsections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sic_uk_section_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sic_uk_subsections_on_sic_uk_section_id` (`sic_uk_section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

CREATE TABLE `slugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `sluggable_id` int(11) DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT '1',
  `sluggable_type` varchar(40) DEFAULT NULL,
  `scope` varchar(40) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_slugs_on_name_and_sluggable_type_and_scope_and_sequence` (`name`,`sluggable_type`,`scope`,`sequence`),
  KEY `index_slugs_on_sluggable_id` (`sluggable_id`)
) ENGINE=MyISAM AUTO_INCREMENT=41964 DEFAULT CHARSET=latin1;

CREATE TABLE `special_advisor_appointing_ministers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `special_advisor_list_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_appointing_ministers_on_special_advisor_list_id` (`special_advisor_list_id`)
) ENGINE=InnoDB AUTO_INCREMENT=213 DEFAULT CHARSET=utf8;

CREATE TABLE `special_advisor_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `at_date` date DEFAULT NULL,
  `data_source_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_special_advisor_lists_on_data_source_id` (`data_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

CREATE TABLE `special_advisors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `qualification` varchar(255) DEFAULT NULL,
  `special_advisor_list_id` int(11) DEFAULT NULL,
  `special_advisor_appointing_minister_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_special_advisors_on_special_advisor_list_id` (`special_advisor_list_id`),
  KEY `index_special_advisors_on_special_advisor_appointing_minister_id` (`special_advisor_appointing_minister_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2034 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20090130170909');

INSERT INTO schema_migrations (version) VALUES ('20090130170922');

INSERT INTO schema_migrations (version) VALUES ('20090130170927');

INSERT INTO schema_migrations (version) VALUES ('20090130171226');

INSERT INTO schema_migrations (version) VALUES ('20090228160229');

INSERT INTO schema_migrations (version) VALUES ('20090301212937');

INSERT INTO schema_migrations (version) VALUES ('20090301214305');

INSERT INTO schema_migrations (version) VALUES ('20090301214347');

INSERT INTO schema_migrations (version) VALUES ('20090302160508');

INSERT INTO schema_migrations (version) VALUES ('20090302160848');

INSERT INTO schema_migrations (version) VALUES ('20090302161558');

INSERT INTO schema_migrations (version) VALUES ('20090302161626');

INSERT INTO schema_migrations (version) VALUES ('20090302162624');

INSERT INTO schema_migrations (version) VALUES ('20090411112213');

INSERT INTO schema_migrations (version) VALUES ('20090715005301');

INSERT INTO schema_migrations (version) VALUES ('20090715010107');

INSERT INTO schema_migrations (version) VALUES ('20090715012200');

INSERT INTO schema_migrations (version) VALUES ('20090715012953');

INSERT INTO schema_migrations (version) VALUES ('20090715013425');

INSERT INTO schema_migrations (version) VALUES ('20090715014126');

INSERT INTO schema_migrations (version) VALUES ('20090715144925');

INSERT INTO schema_migrations (version) VALUES ('20090716003512');

INSERT INTO schema_migrations (version) VALUES ('20090719134753');

INSERT INTO schema_migrations (version) VALUES ('20090719135603');

INSERT INTO schema_migrations (version) VALUES ('20090725143700');

INSERT INTO schema_migrations (version) VALUES ('20090922103040');

INSERT INTO schema_migrations (version) VALUES ('20090928194336');

INSERT INTO schema_migrations (version) VALUES ('20091005131223');

INSERT INTO schema_migrations (version) VALUES ('20091013182456');

INSERT INTO schema_migrations (version) VALUES ('20091013222627');

INSERT INTO schema_migrations (version) VALUES ('20091013222640');

INSERT INTO schema_migrations (version) VALUES ('20091013222706');

INSERT INTO schema_migrations (version) VALUES ('20091017160207');

INSERT INTO schema_migrations (version) VALUES ('20091017160443');

INSERT INTO schema_migrations (version) VALUES ('20091017160643');

INSERT INTO schema_migrations (version) VALUES ('20091019181509');

INSERT INTO schema_migrations (version) VALUES ('20091026095506');