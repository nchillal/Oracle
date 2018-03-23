-- Objects who had high block changes thus causing high redo generation.
SELECT    TO_CHAR(begin_interval_time,'YY-MM-DD HH24') snap_time,
          dhso.object_name,
          SUM(db_block_changes_delta) BLOCK_CHANGED
FROM      dba_hist_seg_stat dhss,
          dba_hist_seg_stat_obj dhso,
          dba_hist_snapshot dhs
WHERE     dhs.snap_id = dhss.snap_id
AND       dhs.instance_number = dhss.instance_number
AND       dhss.obj# = dhso.obj#
AND       dhss.dataobj# = dhso.dataobj#
AND       begin_interval_time > SYSDATE - interval '&mins' minute
GROUP BY  TO_CHAR(begin_interval_time,'YY-MM-DD HH24'), dhso.object_name
HAVING    SUM(db_block_changes_delta) > 0
ORDER BY  SUM(db_block_changes_delta) DESC;

-- SQL Statement generating high redo generation.
SELECT    TO_CHAR(begin_interval_time,'YYYY_MM_DD HH24') WHEN,
          dbms_lob.substr(sql_text,4000,1) SQL,
          dhss.instance_number INST_ID,
          dhss.sql_id,
          executions_delta exec_delta,
          rows_processed_delta rows_proc_delta
FROM      dba_hist_sqlstat dhss,
          dba_hist_snapshot dhs,
          dba_hist_sqltext dhst
WHERE     UPPER(dhst.sql_text) LIKE '%&sql_text%'
AND       LTRIM(UPPER(dhst.sql_text)) NOT LIKE 'SELECT%'
AND       dhss.snap_id = dhs.snap_id
AND       dhss.instance_number = dhs.instance_number
AND       dhss.sql_id = dhst.sql_id
AND       begin_interval_time > SYSDATE - interval '&mins' minute
ORDER BY  rows_proc_delta;

-- Block change count for a specfic object over a period of time.
SELECT    TO_CHAR(begin_interval_time,'YY-MM-DD HH24:MI') snap_time,
          SUM(db_block_changes_delta)
FROM      dba_hist_seg_stat dhss,
          dba_hist_seg_stat_obj dhso,
          dba_hist_snapshot dhs
WHERE     dhs.snap_id = dhss.snap_id
AND       dhs.instance_number = dhss.instance_number
AND       dhss.obj# = dhso.obj#
AND       dhss.dataobj# = dhso.dataobj#
AND       dhso.object_name = '&object_name'
GROUP BY  TO_CHAR(begin_interval_time,'YY-MM-DD HH24:MI')
ORDER BY  TO_CHAR(begin_interval_time,'YY-MM-DD HH24:MI');

-- Block Changes Per Sec from AWR
BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(DB_BLOCK_CHANGES_PER_SEC, 2) "DB_BLOCK_CHANGES_PER_SEC"
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
          FOR metric_name IN ('DB Block Changes Per Sec' AS DB_BLOCK_CHANGES_PER_SEC)
          )
ORDER BY  snap_id;

-- Block Gets Per Sec from AWR
BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(DB_BLOCK_GETS_PER_SEC, 2) "DB_BLOCK_GETS_PER_SEC"
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
          FOR metric_name IN ('DB Block Gets Per Sec' AS DB_BLOCK_GETS_PER_SEC)
          )
ORDER BY  snap_id;

-- Physical Reads Per Sec from AWR
BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(PHY_READ_BYTES_PER_SEC, 2) "PHY_READ_BYTES_PER_SEC"
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
          FOR metric_name IN ('Physical Read Bytes Per Sec' AS PHY_READ_BYTES_PER_SEC)
          )
ORDER BY  snap_id;
