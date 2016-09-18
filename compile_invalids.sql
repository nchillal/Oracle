set pagesize 0 head off feedb off echo off
spool validate_all.sql

SELECT 'alter '||object_type||' '||owner||'.'||object_name||' compile;'
FROM dba_objects WHERE object_type IN ('PROCEDURE','FUNCTION','VIEW','TRIGGER','MATERIALIZED VIEW')
AND status='INVALID' ORDER BY owner
/
SELECT 'alter package '||owner||'.'||object_name||' compile package;'
FROM dba_objects WHERE object_type IN ('PACKAGE')
AND status='INVALID' ORDER BY owner
/
SELECT 'alter package '||owner||'.'||object_name||' compile body;'
FROM dba_objects WHERE object_type IN ('PACKAGE BODY')
AND status='INVALID' ORDER BY owner
/
SELECT 'ALTER JAVA SOURCE "' || object_name || '" COMPILE;'
FROM user_objects WHERE object_type = 'JAVA SOURCE' AND status = 'INVALID';
/
SELECT 'ALTER JAVA CLASS "' || object_name || '" RESOLVE;'
FROM user_objects WHERE object_type = 'JAVA CLASS' AND status = 'INVALID';
/
spool off
exit
