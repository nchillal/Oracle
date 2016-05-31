set pagesize 0 head off feedb off echo off
spool validate_all.sql

select 'alter '||object_type||' '||owner||'.'||object_name||' compile;'
from dba_objects where object_type in ('PROCEDURE','FUNCTION','VIEW','TRIGGER','MATERIALIZED VIEW')
and status='INVALID' order by owner
/
select 'alter package '||owner||'.'||object_name||' compile package;'
from dba_objects where object_type in ('PACKAGE')
and status='INVALID' order by owner
/
select 'alter package '||owner||'.'||object_name||' compile body;'
from dba_objects where object_type in ('PACKAGE BODY')
and status='INVALID' order by owner
/
select 'ALTER JAVA SOURCE "' || object_name || '" COMPILE;'
from user_objects where object_type = 'JAVA SOURCE' and status = 'INVALID';
/
select 'ALTER JAVA CLASS "' || object_name || '" RESOLVE;'
from user_objects where object_type = 'JAVA CLASS' and status = 'INVALID';
/
spool off
exit
