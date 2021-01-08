ALTER TABLE lbaas_listeners MODIFY COLUMN protocol enum('HTTP','HTTPS','TCP','UDP','TERMINATED_HTTPS','FTP');

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
call AddCol(DATABASE(), 'lbaas_sessionpersistences', 'persistence_timeout', 'int AFTER type');
call AddCol(DATABASE(), 'lbaas_loadbalancers', 'bandwidth', 'integer');
