ALTER TABLE lbaas_listeners MODIFY COLUMN protocol enum('HTTP','HTTPS','TCP','UDP','TERMINATED_HTTPS','FTP');
ALTER TABLE lbaas_pools MODIFY COLUMN protocol enum('HTTP','HTTPS','TCP','UDP','FTP');
ALTER TABLE lbaas_l7policies MODIFY column action enum('REJECT','REDIRECT_TO_URL','REDIRECT_TO_HOST','REDIRECT_TO_POOL');

-- ****** NOT WORK IN 21V LAB ******
-- ALTER TABLE lbaas_listeners ADD COLUMN IF NOT EXISTS mutual_authentication_up tinyint(1) AFTER default_tls_container_id;
-- ALTER TABLE lbaas_listeners ADD COLUMN IF NOT EXISTS ca_container_id varchar(128) AFTER mutual_authentication_up;
-- ALTER TABLE lbaas_listeners ADD COLUMN IF NOT EXISTS customized varchar(1024);
-- ALTER TABLE lbaas_sessionpersistences ADD COLUMN IF NOT EXISTS persistence_timeout int AFTER type;
-- ALTER TABLE lbaas_loadbalancers ADD COLUMN IF NOT EXISTS bandwidth integer;

-- ****** Using procedure to solve the problem as blow ******

DROP PROCEDURE IF EXISTS AddCol;

DELIMITER //

CREATE PROCEDURE AddCol(
    IN param_schema VARCHAR(100),
    IN param_table_name VARCHAR(100),
    IN param_column VARCHAR(100),
    IN param_column_details VARCHAR(100)
) 
BEGIN
    IF NOT EXISTS(
    SELECT NULL FROM information_schema.COLUMNS
    WHERE COLUMN_NAME=param_column AND TABLE_NAME=param_table_name AND table_schema = param_schema
    )
    THEN
        set @paramTable = param_table_name ;
        set @ParamColumn = param_column ;
        set @ParamSchema = param_schema;
        set @ParamColumnDetails = param_column_details;
        /* Create the full statement to execute */
        set @StatementToExecute = concat('ALTER TABLE `',@ParamSchema,'`.`',@paramTable,'` ADD COLUMN `',@ParamColumn,'` ',@ParamColumnDetails);
        /* Prepare and execute the statement that was built */
        prepare DynamicStatement from @StatementToExecute ;
        execute DynamicStatement ;
        /* Cleanup the prepared statement */
        deallocate prepare DynamicStatement ;

    END IF;
END //

DELIMITER ;

call AddCol(DATABASE(), 'lbaas_listeners', 'mutual_authentication_up', 'tinyint(1) AFTER default_tls_container_id');
call AddCol(DATABASE(), 'lbaas_listeners', 'ca_container_id', 'varchar(128) AFTER mutual_authentication_up');
call AddCol(DATABASE(), 'lbaas_listeners', 'customized', 'varchar(1024)');
call AddCol(DATABASE(), 'lbaas_listeners', 'transparent', 'bool');
call AddCol(DATABASE(), 'lbaas_listeners', 'tls_protocols', 'varchar(255) AFTER ca_container_id');
call AddCol(DATABASE(), 'lbaas_listeners', 'cipher_suites', 'varchar(4095) AFTER tls_protocols');
call AddCol(DATABASE(), 'lbaas_listeners', 'http2', 'boolean NOT NULL default false AFTER cipher_suites');
call AddCol(DATABASE(), 'lbaas_sessionpersistences', 'persistence_timeout', 'int AFTER type');
call AddCol(DATABASE(), 'lbaas_loadbalancers', 'bandwidth', 'integer');
call AddCol(DATABASE(), 'lbaas_loadbalancers', 'flavor', 'integer');
call AddCol(DATABASE(), 'lbaas_loadbalancers', 'availability_zone_hints', 'varchar(255)');

CREATE TABLE IF NOT EXISTS `lbaas_acl_groups` (
  `project_id` varchar(255) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `lbaas_acl_group_listener_bindings` (
  `listener_id` varchar(36) NOT NULL,
  `acl_group_id` varchar(36) NOT NULL,
  `type` enum('blacklist','whitelist') NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`listener_id`),
  KEY `acl_group_id` (`acl_group_id`),
  CONSTRAINT `lbaas_acl_group_listener_bindings_ibfk_1` FOREIGN KEY (`listener_id`) REFERENCES `lbaas_listeners` (`id`) ON DELETE CASCADE,
  CONSTRAINT `lbaas_acl_group_listener_bindings_ibfk_2` FOREIGN KEY (`acl_group_id`) REFERENCES `lbaas_acl_groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `lbaas_acl_rules` (
  `project_id` varchar(255) DEFAULT NULL,
  `id` varchar(36) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ip_address` varchar(255) NOT NULL,
  `ip_version` enum('IPv4','IPv6') NOT NULL,
  `acl_group_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `acl_group_id` (`acl_group_id`),
  CONSTRAINT `lbaas_acl_rules_ibfk_1` FOREIGN KEY (`acl_group_id`) REFERENCES `lbaas_acl_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- recover manual changes

-- ALTER TABLE lbaas_loadbalancers DROP COLUMN IF EXISTS bandwidth;
-- ALTER TABLE lbaas_loadbalancers DROP COLUMN IF EXISTS flavor;
-- ALTER TABLE lbaas_loadbalancers DROP COLUMN IF EXISTS availability_zone_hints;
-- ALTER TABLE lbaas_sessionpersistences DROP COLUMN IF EXISTS persistence_timeout;
-- ALTER TABLE lbaas_listeners DROP COLUMN IF EXISTS http2;
-- ALTER TABLE lbaas_listeners DROP COLUMN IF EXISTS cipher_suites;
-- ALTER TABLE lbaas_listeners DROP COLUMN IF EXISTS tls_protocols;
-- ALTER TABLE lbaas_listeners DROP COLUMN IF EXISTS transparent;
-- ALTER TABLE lbaas_listeners DROP COLUMN IF EXISTS customized;
-- ALTER TABLE lbaas_listeners DROP COLUMN IF EXISTS ca_container_id;
-- ALTER TABLE lbaas_listeners DROP COLUMN IF EXISTS mutual_authentication_up;
-- DROP TABLE IF EXISTS lbaas_acl_group_listener_bindings;
-- DROP TABLE IF EXISTS lbaas_acl_rules;
-- DROP TABLE IF EXISTS lbaas_acl_groups;
