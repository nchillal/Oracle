SET SERVEROUTOUT ON

-- STEP 1: Verify that the table is a candidate for online redefinition
BEGIN
  DBMS_REDEFINITION.can_redef_table
  (
    '&schema_owner',
    '&original_table_name'
  );
END;
/

-- Step 2: Create an interim table

-- Step 3: Start the redefinition process
BEGIN
  DBMS_REDEFINITION.start_redef_table
  (
    '&schema_owner',
    '&original_table_name',
    '&interim_table_name'
  );
END;
/

-- Step 4: Copy dependent objects
DECLARE
  num_errors PLS_INTEGER;
BEGIN
  DBMS_REDEFINITION.copy_table_dependents
  (
    '&schema_owner',
    '&original_table_name',
    '&interim_table_name',
    DBMS_REDEFINITION.cons_orig_params,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    num_errors
  );
END;
/

-- Step 5: Query the DBA_REDEFINITION_ERRORS view to check for errors
COLUMN sql FORMAT a90
SELECT  object_name, base_table_name, DBMS_LOB.substr(ddl_txt, 2000, 1) sql
FROM    dba_redefinition_errors;

-- Step 6: Optionally, synchronize the interim table
BEGIN
  DBMS_REDEFINITION.sync_interim_table
  (
    '&schema_owner',
    '&original_table_name',
    '&interim_table_name'
  );
END;
/

-- Step 7: Complete the redefinition
BEGIN
  DBMS_REDEFINITION.finish_redef_table
  (
    '&schema_owner',
    '&original_table_name',
    '&interim_table_name'
  );
END;
/

-- Step 8: Wait for any long-running queries against the interim table to complete, and then drop the interim table.
DROP TABLE &schema_owner.&interim_table_name;

-- Reference (https://docs.oracle.com/cd/B28359_01/server.111/b28310/tables007.htm#ADMIN11675)


-- If there is a need to ABORT Redefinition use below SQL.
BEGIN
  DBMS_REDEFINITION.abort_redef_table
  (
    '&schema_name',
    '&original_table_name',
    '&interim_table_name'
  );
END;
/
