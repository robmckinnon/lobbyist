CREATE TABLE `appointees` (
  `id` int(11) NOT NULL auto_increment,
  `person_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL auto_increment,
  `appointee_id` int(11) default NULL,
  `appointment_title` varchar(255) default NULL,
  `appointment_with` varchar(255) default NULL,
  `organisation_id` int(11) default NULL,
  `acoba_advice` text,
  `date_tendered` date default NULL,
  `date_taken_up` date default NULL,
  `type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `former_roles` (
  `id` int(11) NOT NULL auto_increment,
  `appointee_id` int(11) default NULL,
  `department_id` int(11) default NULL,
  `former_department` varchar(255) default NULL,
  `former_role` varchar(255) default NULL,
  `leaving_service_date` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('20090130170909');

INSERT INTO schema_migrations (version) VALUES ('20090130170922');

INSERT INTO schema_migrations (version) VALUES ('20090130170927');

INSERT INTO schema_migrations (version) VALUES ('20090130171226');