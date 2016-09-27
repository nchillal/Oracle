SELECT    TO_CHAR(FIRST_TIME, 'DD-MON-YYYY') as "Date", SUM(blocks * block_size)/1024/1024/1024 as "Total Redo (GB)"
FROM      v$archived_log
WHERE     TO_CHAR(FIRST_TIME, 'DD-MON-YYYY') > TO_CHAR(SYSDATE - &num_days, 'DD-MON-YYYY')
GROUP BY  TO_CHAR(FIRST_TIME, 'DD-MON-YYYY')
ORDER BY  TO_DATE(TO_CHAR(FIRST_TIME, 'DD-MON-YYYY'));

SELECT    begin_time, end_time, intsize_csec, value, metric_unit
FROM      v$sysmetric_history
WHERE     metric_name = 'Redo Generated Per Sec'
ORDER BY  begin_time;
