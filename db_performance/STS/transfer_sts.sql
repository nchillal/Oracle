-- Transporting a SQL Tuning Set
-- Create a staging table where the SQL tuning sets.
EXEC DBMS_SQLTUNE.CREATE_STGTAB_SQLSET(table_name  => 'sts_staging_table', schema_name => 'SYSTEM');

-- Populate the staging table with SQL tuning sets
EXEC DBMS_SQLTUNE.PACK_STGTAB_SQLSET(sqlset_name => '&sqlset_name', sqlset_owner => '&sqlset_owner', staging_table_name => 'sts_staging_table', staging_schema_owner => '&staging_schema_owner');

-- Export dump staging table
expdp dumpfile=sts_staging_table.dmp logfile=sts_staging_table.log directory=DATA_PUMP_DIR tables=dbamaint_user.sts_staging_table

-- Copy the dump file to target database.
scp -rp sts_staging_table.dmp <target>:<target_dest>

-- On Target, import the dump file.
impdp dumpfile=sts_staging_table.dmp logfile=sts_staging_table.log directory=DATA_PUMP_DIR

-- Copy the SQL tuning sets from the staging table into the database.
EXEC DBMS_SQLTUNE.UNPACK_STGTAB_SQLSET(sqlset_name => '%', replace => true, staging_schema_owner => '&staging_schema_owner', staging_table_name => 'sts_staging_table');