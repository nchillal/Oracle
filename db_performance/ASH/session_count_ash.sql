SET LINESIZE 155 PAGESIZE 2000
COMPUTE SUM OF CNT ON username
BREAK ON username SKIP 1

SELECT    du.username username, TO_CHAR(sample_time,'MON-DD-YYYY') DAY, TO_CHAR(sample_time,'HH24:MI') HH24MM, COUNT(*) CNT
FROM      v$active_session_history ash, dba_users du
WHERE     ash.user_id = du.user_id
AND       du.user_id <> 0
AND       sample_time >= TO_DATE('&start_datetime','DDMMRRHH24MI')
AND       sample_time <= TO_DATE('&end_datetime','DDMMRRHH24MI')
GROUP BY  du.username, TO_CHAR(sample_time,'MON-DD-YYYY'), TO_CHAR(sample_time,'HH24:MI')
ORDER BY  1,2,3;

SELECT    du.username username, TO_CHAR(sample_time,'MON-DD-YYYY') DAY, TO_CHAR(sample_time,'HH24:MI') HH24MM, COUNT(*) CNT
FROM      dba_hist_active_sess_history dash, dba_users du
WHERE     dash.user_id = du.user_id
AND       du.user_id <> 0
AND       snap_id BETWEEN '&&begin_snap' AND '&&end_snap'
GROUP BY  du.username, TO_CHAR(sample_time,'MON-DD-YYYY'), TO_CHAR(sample_time,'HH24:MI')
ORDER BY  1,2,3;
