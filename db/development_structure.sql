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
  KEY `index_consultancy_clients_on_register_entry_id` (`register_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  PRIMARY KEY  (`id`),
  KEY `index_data_sources_on_organisation_id` (`organisation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  KEY `index_monitoring_clients_on_register_entry_id` (`register_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `office_contacts` (
  `id` int(11) NOT NULL auto_increment,
  `register_entry_id` int(11) default NULL,
  `details` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_office_contacts_on_register_entry_id` (`register_entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `organisations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `wikipedia_url` varchar(255) default NULL,
  `spinwatch_url` varchar(255) default NULL,
  `company_number` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `wikipedia_url` varchar(255) default NULL,
  `spinwatch_url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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