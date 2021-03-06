SET LINESIZE 155 PAGESIZE 2000
COMPUTE SUM OF CNT ON username
BREAK ON username SKIP 1

SELECT    ash.inst_id, du.username username, TO_CHAR(sample_time,'MON-DD-YYYY') DAY, TO_CHAR(sample_time,'HH24:MI') HH24MM, COUNT(*) CNT
FROM      gv$active_session_history ash, dba_users du
WHERE     ash.user_id = du.user_id
AND       du.user_id <> 0
AND       sample_time >= TO_DATE('&&start_datetime','DDMMRRHH24MI')
AND       sample_time <= TO_DATE('&&end_datetime','DDMMRRHH24MI')
GROUP BY  ash.inst_id, du.username, TO_CHAR(sample_time,'MON-DD-YYYY'), TO_CHAR(sample_time,'HH24:MI')
ORDER BY  1,2,3;

SELECT    dash.instance_number, du.username username, TO_CHAR(sample_time,'MON-DD-YYYY') DAY, TO_CHAR(sample_time,'HH24:MI') HH24MM, COUNT(*) CNT
FROM      dba_hist_active_sess_history dash, dba_users du
WHERE     dash.user_id = du.user_id
AND       du.user_id <> 0
AND       snap_id BETWEEN '&&begin_snap' AND '&&end_snap'
GROUP BY  dash.instance_number, du.username, TO_CHAR(sample_time,'MON-DD-YYYY'), TO_CHAR(sample_time,'HH24:MI')
ORDER BY  1,2,3;

SELECT username, TO_CHAR(sample_time,'YYYY-MM-DD') DAY, COUNT(*) CNT
FROM
(
    SELECT    du.username username, sample_time
    FROM      gv$active_session_history ash, dba_users du
    WHERE     ash.user_id = du.user_id
    AND       du.user_id <> 0
    AND       du.username = '&&username'
    UNION
    SELECT    du.username username, sample_time
    FROM      dba_hist_active_sess_history dash, dba_users du
    WHERE     dash.user_id = du.user_id
    AND       du.user_id <> 0
    AND       du.username = '&&username'
)
GROUP BY username, TO_CHAR(sample_time,'YYYY-MM-DD')
ORDER BY 2;
