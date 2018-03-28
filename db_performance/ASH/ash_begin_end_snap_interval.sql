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
);

SET SERVEROUTPUT ON
DECLARE
  CURSOR c1 IS
    SELECT  *
    FROM
    (
      SELECT  TO_CHAR(sample_time, 'DDMMRRHH24MI') stime, LEAD(TO_CHAR(sample_time, 'DDMMRRHH24MI'), 1) OVER (ORDER BY sample_time) etime
      FROM    v$active_session_history
      WHERE   sample_time > SYSDATE - INTERVAL '&hour' HOUR
      AND     REGEXP_LIKE(TO_CHAR(sample_time, 'MI'), '00|15|30|45')
    ) ash
    WHERE ash.stime < ash.etime;
    sql_id VARCHAR2(30);
    cnt NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(chr(13));
  FOR i IN c1
  LOOP
    DBMS_OUTPUT.PUT_LINE(i.stime||' ---> '||i.etime);
  END LOOP;
END;
/

SET SERVEROUTPUT ON
DECLARE
  CURSOR c1 IS
    SELECT  *
    FROM
    (
      SELECT  TO_CHAR(begin_interval_time, 'DDMMRRHH24MI') stime, LEAD(TO_CHAR(begin_interval_time, 'DDMMRRHH24MI'), 1) OVER (ORDER BY begin_interval_time) etime
      FROM    dba_hist_snapshot
      WHERE   TO_CHAR(begin_interval_time, 'DDMMRR') = '&day'
      AND     REGEXP_LIKE(TO_CHAR(begin_interval_time, 'MI'), '00|15|30|45')
    ) ash
    WHERE ash.stime < ash.etime;
    sql_id VARCHAR2(30);
    cnt NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(chr(13));
  FOR i IN c1
  LOOP
    DBMS_OUTPUT.PUT_LINE(i.stime||' ---> '||i.etime);
  END LOOP;
END;
/
