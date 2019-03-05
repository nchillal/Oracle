-- How to transport a SQL profile from one database to another.

-- Create staging table to copy sql profiles.
BEGIN
    DBMS_SQLTUNE.CREATE_STGTAB_SQLPROF
    (
        table_name  => '&staging_table_name',
        schema_name => '&schema_name'
    );
END;
/

-- Export SQL profiles into the staging table
BEGIN
    DBMS_SQLTUNE.PACK_STGTAB_SQLPROF
    (
        profile_name         => 'my_profile',
        staging_table_name   => 'my_staging_table',
        staging_schema_owner => 'dba1'
    );
END;
/

-- Move the staging table to the database where you plan to unpack the SQL profiles.
-- Move the table using your utility of choice. For example, use Oracle Data Pump or a database link.

-- Unpack SQL profiles from the staging table
BEGIN
    DBMS_SQLTUNE.UNPACK_STGTAB_SQLPROF
    (
        replace => true,
        staging_table_name => '&staging_table_name'
    );
END;
/

