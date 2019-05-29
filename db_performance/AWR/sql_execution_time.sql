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
BREAK ON plan_hash_value SKIP 1
SELECT      begin_interval_time "BEGIN_TIME",
            plan_hash_value,
            executions_delta executions,
            ROUND(rows_processed_delta/executions_delta) rows_per_exec,
            ROUND(elapsed_time_delta/executions_delta/1000, 0) ela_per_exec_ms,
            ROUND(buffer_gets_delta/executions_delta, 0) buf_gets_per_exec,
            ROUND(physical_read_bytes_delta/executions_delta) phy_reads_per_exec
FROM        dba_hist_sqlstat dhs, dba_hist_snapshot dhss
WHERE       dhs.dbid = dhss.dbid
AND         dhs.instance_number = dhss.instance_number
AND         dhs.snap_id = dhss.snap_id
AND         sql_id = '&sql_id'
AND         executions_delta > 0
ORDER BY    2, 1;

SELECT      executions,
            ROUND(rows_processed/executions) rows_per_exec,
            ROUND(elapsed_time/executions/1000, 0) ela_per_exec_ms,
            ROUND(buffer_gets/executions, 0) buf_gets_per_exec,
            ROUND(physical_read_bytes/executions) phy_reads_per_exec_bytes,
            ROUND(physical_read_requests/executions) phy_write_per_exec_bytes
FROM        v$sqlstats
WHERE       sql_id = '&sql_id';