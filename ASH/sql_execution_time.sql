BREAK ON sql_id
COLUMN start_time FORMAT a30
COLUMN end_time FORMAT a30
COLUMN time_taken FORMAT a30

SELECT    sql_id, sql_exec_id, sql_plan_hash_value, sql_exec_start "START_TIME", MAX(sample_time) "END_TIME", EXTRACT(HOUR FROM (MAX(sample_time) - sql_exec_start))||' Hour '||EXTRACT(MINUTE FROM (MAX(sample_time) - MIN(sample_time))) ||' Minute ' "TIME_TAKEN"
FROM      dba_hist_active_sess_history
WHERE     sql_id = '&sql_id'
AND       sample_time >= SYSDATE - INTERVAL '&days' day
AND       sql_exec_id IS NOT NULL
GROUP BY  sql_id, sql_exec_id, sql_plan_hash_value, sql_exec_start
ORDER BY  sql_exec_id;
