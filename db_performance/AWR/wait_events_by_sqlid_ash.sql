-- To get it from Shared Pool.
SELECT    NVL(event, 'ON CPU') event, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
FROM      v$active_session_history
WHERE     sample_time > TO_DATE('&&start_datetime','DDMMRRHH24MI')
AND       sample_time < TO_DATE('&&end_datetime','DDMMRRHH24MI')
GROUP BY  event
ORDER BY  2 DESC;

SELECT    NVL(event, 'ON CPU') event, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
FROM      v$active_session_history
WHERE     sample_time > TO_DATE('&&start_datetime','DDMMRRHH24MI')
AND       sample_time < TO_DATE('&&end_datetime','DDMMRRHH24MI')
AND       sql_id = '&&sql_id'
GROUP BY  event
ORDER BY  2 DESC;

SELECT    NVL(event, 'ON CPU') event, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
FROM      v$active_session_history
WHERE     sql_id = '&&sql_id'
GROUP BY  event
ORDER BY  2 DESC;

SELECT    NVL(event, 'ON CPU') event, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
FROM      v$active_session_history
WHERE     sample_time > TO_DATE('&&start_datetime','DDMMRRHH24MI')
AND       sample_time < TO_DATE('&&end_datetime','DDMMRRHH24MI')
GROUP BY  event
ORDER BY  2 DESC;

-- To obtain from AWR.
SELECT    NVL(event, 'ON CPU') event, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
FROM      dba_hist_active_sess_history
WHERE     snap_id BETWEEN &&begin_snap AND &&end_snap
GROUP BY  event
ORDER BY  2 DESC;

SELECT    NVL(event, 'ON CPU') event, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
FROM      dba_hist_active_sess_history
WHERE     sql_id = '&&sql_id'
AND       snap_id BETWEEN &&begin_snap AND &&end_snap
GROUP BY  event
ORDER BY  2 DESC;

SELECT    NVL(event, 'ON CPU') event, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
FROM      dba_hist_active_sess_history
WHERE     sql_id = '&&sql_id'
GROUP BY  event
ORDER BY  2 DESC;
