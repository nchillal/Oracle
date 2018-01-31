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
