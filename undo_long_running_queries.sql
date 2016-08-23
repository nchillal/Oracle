COLUMN sql_fulltext FORMAT a90

SELECT  sql_id, sql_fulltext, last_load_time "Last Load", ROUND(elapsed_time/60/60/24) "Elapsed Days" 
FROM    v$sql 
WHERE   sql_id IN (SELECT maxquerysqlid FROM sys.wrh$_undostat WHERE status > 1)
/
