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
AND       begin_interval_time BETWEEN TO_DATE('&start_time','YY-MM-DD HH24:MI') AND TO_DATE('&end_time','YY-MM-DD HH24:MI')
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
AND       begin_interval_time BETWEEN TO_DATE('&start_time','YY-MM-DD HH24:MI') AND TO_DATE('&end_time','YY-MM-DD HH24:MI')
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
