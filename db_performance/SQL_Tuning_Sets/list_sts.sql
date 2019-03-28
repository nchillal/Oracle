-- To display the contents of an STS
SET NUM 16
COLUMN SQL_TEXT FORMAT a100

SELECT parsing_schema_name, sql_id, plan_hash_value, elapsed_time, buffer_gets, executions
FROM   TABLE(DBMS_SQLTUNE.SELECT_SQLSET('&&sqlset_name'));