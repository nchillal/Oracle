SELECT    *
FROM      (
          SELECT    sql_id,
                    time_waited "time_waited(s)",
                    CASE WHEN time_waited = 0 THEN
                      0
                    ELSE
                      ROUND(time_waited*100 / SUM(time_waited) OVER(), 2)
                    END "percentage"
          FROM      (
                    SELECT    sql_id, SUM(time_waited) time_waited
                    FROM      v$active_session_history
                    WHERE     sample_time > TO_DATE('&start_datetime','DDMMRRHH24MI')
                    AND       sample_time < TO_DATE('&end_datetime','DDMMRRHH24MI')
                    AND       user_id > 0
                    AND       event = '&event'
                    GROUP BY  sql_id
                    )
          ORDER BY  time_waited DESC
)
WHERE   rownum <= 20;

SELECT    *
FROM      (
          SELECT    sql_id,
                    time_waited "time_waited(s)",
                    CASE WHEN time_waited = 0 THEN
                      0
                    ELSE
                      ROUND(time_waited*100 / SUM(time_waited) OVER(), 2)
                    END "percentage"
          FROM      (
                    SELECT    sql_id, SUM(time_waited) time_waited
                    FROM      dba_hist_active_sess_history
                    WHERE     sample_time > TO_DATE('&start_datetime','DDMMRRHH24MI')
                    AND       sample_time < TO_DATE('&end_datetime','DDMMRRHH24MI')
                    AND       user_id > 0
                    AND       event = '&event'
                    GROUP BY  sql_id
                    )
          ORDER BY  time_waited DESC
)
WHERE   rownum <= 20;
