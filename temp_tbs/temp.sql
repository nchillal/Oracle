SELECT username, session_num session_serial#, sql_id, SUM(blocks)*8192/1048576 Temp_MB
FROM v$tempseg_usage
WHERE tablespace = '&temp_tablespace'
GROUP BY username, session_num, sql_id
ORDER BY 4
/
