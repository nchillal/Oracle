BREAK ON sql_id
COLUMN start_time FORMAT a30
COLUMN end_time FORMAT a30
COLUMN time_taken FORMAT a30

SELECT    sql_id,
          snap_id,
          sql_exec_id,
          sql_plan_hash_value,
          MIN(sample_time) "START_TIME",
          MAX(sample_time) "END_TIME",
          EXTRACT(HOUR FROM (MAX(sample_time) - MIN(sample_time)))||' Hour '||EXTRACT(MINUTE FROM (MAX(sample_time) - MIN(sample_time))) ||' Minute '||ROUND(EXTRACT(SECOND FROM (MAX(sample_time) - MIN(sample_time)))) ||' Second ' "TIME_TAKEN"
FROM      dba_hist_active_sess_history
WHERE     sql_id = '&&sql_id'
AND       sample_time >= SYSDATE - INTERVAL '&days' day
AND       sql_exec_id IS NOT NULL
GROUP BY  snap_id, sql_id, sql_exec_id, sql_plan_hash_value
ORDER BY  sql_exec_id;

COLUMN begin_time FORMAT a30
SELECT      begin_interval_time "BEGIN_TIME", executions_delta executions, ROUND(rows_processed_delta/executions_delta) rows_per_exec, ROUND(elapsed_time_delta/executions_delta/1000, 0) ela_per_exec_ms
FROM        dba_hist_sqlstat dhs, dba_hist_snapshot dhss
WHERE       dhs.dbid = dhss.dbid
AND         dhs.instance_number = dhss.instance_number
AND         dhs.snap_id = dhss.snap_id
AND         sql_id = '&sql_id'
ORDER BY    1;

SELECT      executions, round(rows_processed/executions) rows_per_exec, round(elapsed_time/executions/1000) ela_per_exec_ms
FROM        v$sqlstats
WHERE       sql_id = '&sql_id';