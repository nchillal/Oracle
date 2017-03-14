-- Query to obtain redo generation per day.
SELECT    TO_CHAR(FIRST_TIME, 'DD-MON-YYYY') as "Date", SUM(blocks * block_size)/1024/1024/1024 as "Total Redo (GB)"
FROM      v$archived_log
WHERE     DEST_ID = 1
AND       TO_CHAR(FIRST_TIME, 'DD-MON-YYYY') > TO_CHAR(SYSDATE - &num_days, 'DD-MON-YYYY')
GROUP BY  TO_CHAR(FIRST_TIME, 'DD-MON-YYYY')
ORDER BY  TO_DATE(TO_CHAR(FIRST_TIME, 'DD-MON-YYYY'));

-- Query to obtain redo generation per hour.
SET PAGESIZE 200 LINESIZE 155
BREAK ON DAY SKIP 1
COMPUTE SUM LABEL 'TOTAL' OF "REDO (MB)" ON DAY
SELECT    TO_CHAR(BEGIN_TIME, 'DD-MON-YYYY') "Day", TO_CHAR(BEGIN_TIME, 'HH24') "HR", SUM(value) "REDO (MB)"
FROM      (
          SELECT    begin_time, value/1024/1024 value
          FROM      dba_hist_sysmetric_history
          WHERE     metric_name = 'Redo Generated Per Sec'
          UNION
          SELECT    begin_time, value/1024/1024 "REDO (MB)"
          FROM      v$sysmetric_history
          WHERE     metric_name = 'Redo Generated Per Sec'
          ORDER BY  begin_time
          )
WHERE     begin_time > SYSDATE - &hrs/24
GROUP BY  TO_CHAR(begin_time, 'DD-MON-YYYY'), TO_CHAR(BEGIN_TIME, 'HH24')
ORDER BY  TO_DATE(TO_CHAR(begin_time, 'DD-MON-YYYY')), TO_CHAR(BEGIN_TIME, 'HH24');

-- Query to obtain redo generation per min.
SELECT    *
FROM      (
          SELECT    begin_time, end_time, value/1024/1024 "REDO (MB)"
          FROM      dba_hist_sysmetric_history
          WHERE     metric_name = 'Redo Generated Per Sec'
          UNION
          SELECT    begin_time, end_time, value/1024/1024 "REDO (MB)"
          FROM      v$sysmetric_history
          WHERE     metric_name = 'Redo Generated Per Sec'
          ORDER BY  begin_time
          )
WHERE     begin_time > SYSDATE - &mins/1440;
