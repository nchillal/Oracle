select username, session_num session_serial#, sql_id, sum(blocks)*8192/1048576 Temp_MB
from v$tempseg_usage
where tablespace = '&temp_tablespace'
group by username, session_num, sql_id
order by 3
/
