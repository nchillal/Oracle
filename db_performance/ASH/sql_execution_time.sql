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
WHERE     sql_id = '&sql_id'
AND       sample_time >= SYSDATE - INTERVAL '&days' day
AND       sql_exec_id IS NOT NULL
GROUP BY  snap_id, sql_id, sql_exec_id, sql_plan_hash_value
ORDER BY  sql_exec_id;


-- Executions Per Sec from AWR
BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(EXEC_PER_SEC, 2) "EXEC_PER_SEC"
FROM      (
          SELECT  snap_id,
                  instance_number,
                  end_time,
                  metric_name,
                  maxval
          FROM    dba_hist_sysmetric_summary
          WHERE   end_time >= SYSDATE - INTERVAL '&days' day
          AND     REGEXP_LIKE(instance_number, '&instance_number')
          )
PIVOT     (
          MAX(maxval)
          FOR metric_name IN ('Executions Per Sec' AS EXEC_PER_SEC)
          )
ORDER BY  snap_id;

-- DB Time Per Sec from AWR
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(DB_TIME_PER_SEC, 2) "DB_TIME_PER_SEC"
FROM      (
          SELECT  snap_id,
          instance_number,
          end_time,
          metric_name,
          maxval
          FROM    dba_hist_sysmetric_summary
          WHERE   end_time >= SYSDATE - INTERVAL '&days' day
          AND     REGEXP_LIKE(instance_number, '&instance_number')
          )
PIVOT     (
          MAX(maxval)
          FOR metric_name IN ('Database Time Per Sec' AS DB_TIME_PER_SEC)
          )
ORDER BY  snap_id;
