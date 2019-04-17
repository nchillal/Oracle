-- Creating a SQL Tuning Set
EXEC DBMS_SQLTUNE.CREATE_SQLSET(sqlset_name => '&sqlset_name', description => '&description');