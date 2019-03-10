COLUMN begin_end_snapid FORMAT a20
SELECT    begin_snap||' ---> '||end_snap "BEGIN_END_SNAPID",
          begin_time||' ---> '||end_time "BEGIN_END_SNAPTIME"
FROM
(
          SELECT  snap_id "BEGIN_SNAP",
                  LEAD(SNAP_ID, 1) OVER(ORDER BY snap_id) "END_SNAP",
                  TO_CHAR(BEGIN_INTERVAL_TIME, 'DDMMRRHH24MI') "BEGIN_TIME",
                  LEAD(TO_CHAR(BEGIN_INTERVAL_TIME, 'DDMMRRHH24MI'), 1) OVER(ORDER BY snap_id) "END_TIME"
          FROM    dba_hist_snapshot
          WHERE   instance_number = 1
          AND     begin_interval_time > SYSDATE - INTERVAL '&days' DAY
);

COLUMN begin_end_snapid FORMAT a20
SELECT    begin_snap||' ---> '||end_snap "BEGIN_END_SNAPID",
          begin_time||' ---> '||end_time "BEGIN_END_SNAPTIME"
FROM
(
          SELECT  snap_id "BEGIN_SNAP",
                  LEAD(SNAP_ID, 1) OVER(ORDER BY snap_id) "END_SNAP",
                  TO_CHAR(BEGIN_INTERVAL_TIME, 'DDMMRRHH24MI') "BEGIN_TIME",
                  LEAD(TO_CHAR(BEGIN_INTERVAL_TIME, 'DDMMRRHH24MI'), 1) OVER(ORDER BY snap_id) "END_TIME"
          FROM    dba_hist_snapshot
          WHERE   instance_number = 1
          AND     begin_interval_time > SYSDATE - INTERVAL '&hours' HOUR
);
