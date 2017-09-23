BREAK ON begin_time SKIP 1
COMPUTE SUM LABEL 'TOTAL' OF UNDO_SIZE_MB ON begin_time

SELECT  a.begin_time "BEGIN_TIME", a.instance_number "INSTANCE_NUMBER", ROUND((a.undoblks * b.value)/1024/1024, 2) "UNDO_SIZE_MB"
FROM    (
          SELECT    instance_number, TO_CHAR(begin_time, 'DD-MON-YYYY') "BEGIN_TIME", SUM(undoblks) "UNDOBLKS"
          FROM      dba_hist_undostat
          WHERE     begin_time > SYSDATE - INTERVAL '&days' DAY
          GROUP BY  instance_number, TO_CHAR(begin_time, 'DD-MON-YYYY')
        ) a,
        (SELECT value FROM v$parameter WHERE name='db_block_size') b
ORDER BY 1,2,3;

CLEAR COMPUTE

BREAK ON day ON hour_min SKIP 1
SELECT  a.day "DAY", a.hour_min "HOUR_MIN", a.instance_number "INSTANCE_NUMBER", ROUND((a.undoblks * b.value)/1024/1024, 2) "UNDO_SIZE_MB"
FROM    (
          SELECT    instance_number, TO_CHAR(begin_time, 'DD-MON-YYYY') "DAY", TO_CHAR(begin_time, 'HH24:MI') "HOUR_MIN", SUM(undoblks) "UNDOBLKS"
          FROM      dba_hist_undostat
          WHERE     begin_time > SYSDATE - INTERVAL '&mins' MINUTE
          GROUP BY  instance_number, TO_CHAR(begin_time, 'DD-MON-YYYY'), TO_CHAR(begin_time, 'HH24:MI')
        ) a,
        (SELECT value FROM v$parameter WHERE name='db_block_size') b
ORDER BY 1,2,3;

BREAK ON DAY ON HOUR_MIN SKIP 1
SELECT  a.day "DAY", a.hour_min "HOUR_MIN", a.inst_id "INSTANCE_NUMBER", ROUND((a.undoblks * b.value)/1024/1024, 2) "UNDO_SIZE_MB"
FROM    (
          SELECT inst_id, TO_CHAR(begin_time, 'DD-MON-YYYY') "DAY", TO_CHAR(begin_time, 'HH24:MI') "HOUR_MIN", SUM(undoblks) "UNDOBLKS"
          FROM gv$undostat
          WHERE begin_time > SYSDATE - INTERVAL '&mins' MINUTE
          GROUP BY inst_id, TO_CHAR(begin_time, 'DD-MON-YYYY'), TO_CHAR(begin_time, 'HH24:MI')
        ) a,
        (SELECT value FROM v$parameter WHERE name='db_block_size') b
ORDER BY 1,2,3;
