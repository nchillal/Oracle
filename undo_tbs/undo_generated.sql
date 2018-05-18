SELECT  a.begin_time "BEGIN_TIME", a.instance_number "INSTANCE_NUMBER", ROUND((a.undoblks * b.value)/1024/1024, 2) "UNDO_SIZE_MB"
FROM    (
          SELECT    instance_number, TO_CHAR(begin_time, 'DD-MON-YYYY') "BEGIN_TIME", SUM(undoblks) "UNDOBLKS"
          FROM      dba_hist_undostat
          WHERE     begin_time > SYSDATE - INTERVAL '&days' DAY
          GROUP BY  instance_number, TO_CHAR(begin_time, 'DD-MON-YYYY')
        ) a,
        (SELECT value FROM v$parameter WHERE name='db_block_size') b
ORDER BY 1,2,3;

SELECT  a.day "DAY", a.hour_min "HOUR_MIN", a.instance_number "INSTANCE_NUMBER", ROUND((a.undoblks * b.value)/1024/1024, 2) "UNDO_SIZE_MB"
FROM    (
          SELECT    instance_number, TO_CHAR(begin_time, 'DD-MON-YYYY') "DAY", TO_CHAR(begin_time, 'HH24:MI') "HOUR_MIN", SUM(undoblks) "UNDOBLKS"
          FROM      dba_hist_undostat
          WHERE     begin_time > SYSDATE - INTERVAL '&mins' MINUTE
          GROUP BY  instance_number, TO_CHAR(begin_time, 'DD-MON-YYYY'), TO_CHAR(begin_time, 'HH24:MI')
        ) a,
        (SELECT value FROM v$parameter WHERE name='db_block_size') b
ORDER BY 1,2,3;

SELECT  a.day "DAY", a.hour_min "HOUR_MIN", a.inst_id "INSTANCE_NUMBER", ROUND((a.undoblks * b.value)/1024/1024, 2) "UNDO_SIZE_MB"
FROM    (
          SELECT inst_id, TO_CHAR(begin_time, 'DD-MON-YYYY') "DAY", TO_CHAR(begin_time, 'HH24:MI') "HOUR_MIN", SUM(undoblks) "UNDOBLKS"
          FROM gv$undostat
          WHERE begin_time > SYSDATE - INTERVAL '&mins' MINUTE
          GROUP BY inst_id, TO_CHAR(begin_time, 'DD-MON-YYYY'), TO_CHAR(begin_time, 'HH24:MI')
        ) a,
        (SELECT value FROM v$parameter WHERE name='db_block_size') b
ORDER BY 1,2,3;

SELECT  s.sid, s.serial#, s.status,
        sql.sql_id "SQL_ID",
        t.used_urec "RECORDS",
        t.used_ublk "BLOCKS",
        (t.used_ublk*8192) "BYTES"
FROM    v$transaction t, v$session s, v$sql sql
WHERE   t.addr = s.taddr
AND     s.sql_id = sql.sql_id;
