SELECT username, session_num session_serial#, sql_id, SUM(blocks)*8192/1048576 Temp_MB
FROM v$tempseg_usage
where tablespace = '&temp_tablespace'
group by username, session_num, sql_id
ORDER BY 3
/
