-- To verify the execution Plan of a SQL_ID in the STS
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQLSET('&&sqlset_name','&&sql_id'));