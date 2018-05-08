SELECT    sql_id, percentage
FROM
(
  SELECT    sql_id, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
  FROM      v$active_session_history
  WHERE     sample_time > TO_DATE('&&start_datetime','DDMMRRHH24MI')
  AND       sample_time < TO_DATE('&&end_datetime','DDMMRRHH24MI')
  AND       user_id > 0
  AND       event = '&&event'
  GROUP BY  sql_id
  ORDER BY  2 DESC
)
WHERE percentage > 0;

SELECT    sql_id, percentage
FROM
(
  SELECT    sql_id, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
  FROM      dba_hist_active_sess_history
  WHERE     snap_id BETWEEN &&begin_snap AND &&end_snap
  AND       user_id > 0
  AND       event = '&&event'
  GROUP BY  sql_id
  ORDER BY  2 DESC
)
WHERE percentage > 0;
