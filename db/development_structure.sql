CREATE TABLE `appointees` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `data_source_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_appointees_on_person_id` (`person_id`),
  KEY `index_appointees_on_data_source_id` (`data_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL auto_increment,
  `appointee_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `organisation_name` varchar(255) default NULL,
  `organisation_id` int(11) default NULL,
  `acoba_advice` text,
  `date_tendered` date default NULL,
  `date_taken_up` date default NULL,
  `type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_appointments_on_appointee_id` (`appointee_id`),
  KEY `index_appointments_on_organisation_id` (`organisation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `consultancy_clients` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `name_in_parentheses` text,
  `organisation_id` int(11) default NULL,
  `register_entry_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_consultancy_clients_on_organisation_id` (`organisation_id`),
  KEY `index_consultancy_clients_on_register_entry_id` (`register_entry_id`),
  KEY `index_consultancy_clients_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3121 DEFAULT CHARSET=utf8;

CREATE TABLE `consultancy_staff_members` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `person_id` int(11) default NULL,
  `register_entry_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_consultancy_staff_members_on_person_id` (`person_id`),
  KEY `index_consultancy_staff_members_on_register_entry_id` (`register_entry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1607 DEFAULT CHARSET=utf8;

CREATE TABLE `data_sources` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `long_name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `organisation_id` int(11) default NULL,
  `period_start` date default NULL,
  `period_end` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `as_at_date` date default NULL,
  `file` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_data_sources_on_organisation_id` (`organisation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `former_roles` (
  `id` int(11) NOT NULL auto_increment,
  `appointee_id` int(11) default NULL,
  `department_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `department_name` varchar(255) default NULL,
  `leaving_service_date` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_former_roles_on_appointee_id` (`appointee_id`),
  KEY `index_former_roles_on_department_id` (`department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `members` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `publicwhip_id` varchar(255) default NULL,
  `house` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `firstname` varchar(255) default NULL,
  `lastname` varchar(255) default NULL,
  `constituency` varchar(255) default NULL,
  `party` varchar(255) default NULL,
  `from_date` date default NULL,
  `to_date` date default NULL,
  `from_why` varchar(255) default NULL,
  `to_why` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_members_on_person_id` (`person_id`),
  KEY `index_members_on_publicwhip_id` (`publicwhip_id`),
  KEY `index_members_on_party` (`party`)
) ENGINE=InnoDB AUTO_INCREMENT=2038 DEFAULT CHARSET=utf8;

CREATE TABLE `members_interests_categories` (
  `id` int(11) NOT NULL auto_increment,
  `number` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `members_interests_entries` (
  `id` int(11) NOT NULL auto_increment,
  `member_id` int(11) default NULL,
  `data_source_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_members_interests_entries_on_member_id` (`member_id`),
  KEY `index_members_interests_entries_on_data_source_id` (`data_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `members_interests_items` (
  `id` int(11) NOT NULL auto_increment,
  `members_interests_category_id` int(11) default NULL,
  `members_interests_entry_id` int(11) default NULL,
  `subcategory` varchar(255) default NULL,
  `description` text,
  `range_amount_text` varchar(255) default NULL,
  `actual_amount_text` varchar(255) default NULL,
  `up_to_amount_text` varchar(255) default NULL,
  `from_amount_text` varchar(255) default NULL,
  `actual_amount` int(11) default NULL,
  `up_to_amount` int(11) default NULL,
  `from_amount` int(11) default NULL,
  `currency_symbol` varchar(255) default NULL,
  `registered_date_text` varchar(255) default NULL,
  `registered_date` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_members_interests_items_on_members_interests_category_id` (`members_interests_category_id`),
  KEY `index_members_interests_items_on_members_interests_entry_id` (`members_interests_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `monitoring_clients` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `name_in_parentheses` text,
  `organisation_id` int(11) default NULL,
  `register_entry_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_monitoring_clients_on_organisation_id` (`organisation_id`),
  KEY `index_monitoring_clients_on_register_entry_id` (`register_entry_id`),
  KEY `index_monitoring_clients_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8;

CREATE TABLE `office_contacts` (
  `id` int(11) NOT NULL auto_increment,
  `register_entry_id` int(11) default NULL,
  `details` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_office_contacts_on_register_entry_id` (`register_entry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;

CREATE TABLE `organisations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `alternate_name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `wikipedia_url` varchar(255) default NULL,
  `spinwatch_url` varchar(255) default NULL,
  `company_number` varchar(255) default NULL,
  `registered_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_organisations_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2075 DEFAULT CHARSET=utf8;

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `wikipedia_url` varchar(255) default NULL,
  `spinwatch_url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `publicwhip_id` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_people_on_publicwhip_id` (`publicwhip_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4295 DEFAULT CHARSET=utf8;

CREATE TABLE `register_entries` (
  `id` int(11) NOT NULL auto_increment,
  `organisation_name` varchar(255) default NULL,
  `organisation_url` varchar(255) default NULL,
  `organisation_id` int(11) default NULL,
  `data_source_id` int(11) default NULL,
  `declaration_signed_or_submitted` varchar(255) default NULL,
  `offices_outside_the_uk` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_register_entries_on_data_source_id` (`data_source_id`),
  KEY `index_register_entries_on_organisation_id` (`organisation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `slugs` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `sluggable_id` int(11) default NULL,
  `sequence` int(11) NOT NULL default '1',
  `sluggable_type` varchar(40) default NULL,
  `scope` varchar(40) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_slugs_on_name_and_sluggable_type_and_scope_and_sequence` (`name`,`sluggable_type`,`scope`,`sequence`),
  KEY `index_slugs_on_sluggable_id` (`sluggable_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6373 DEFAULT CHARSET=latin1;

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