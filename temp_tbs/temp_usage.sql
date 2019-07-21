COLUMN sid_serial FORMAT a10
COLUMN username FORMAT a17
COLUMN osuser FORMAT a15
COLUMN spid FORMAT 99999
COLUMN module FORMAT a15
COLUMN program FORMAT a30
COLUMN mb_used FORMAT 999999.999
COLUMN mb_total FORMAT 999999.999
COLUMN tablespace FORMAT a15
COLUMN statements FORMAT 999
COLUMN hash_value FORMAT 99999999999
COLUMN sql_text FORMAT a50
COLUMN service_name FORMAT a15

SELECT    s.sid||','||s.serial# sid_serial, 
          s.username, s.osuser, p.spid, 
          s.module,
          SUM(t.blocks)*tbs.block_size/1024/1024 mb_used, T.tablespace,
          COUNT(*) statements
FROM      v$tempseg_usage t, v$session s, dba_tablespaces tbs, v$process p
WHERE     T.session_addr = S.saddr
AND       S.paddr = P.addr
AND       T.tablespace = tbs.tablespace_name
GROUP BY  S.sid, S.serial#, S.username, S.osuser, P.spid, S.module, P.program, s.service_name, tbs.block_size, T.tablespace
ORDER BY  mb_used;

SELECT    sysdate "TIME_STAMP",
          vsu.username,
          vs.sid,
          vp.spid,
          vs.sql_id,
          vsu.segtype,
          vsu.tablespace,
          vs.service_name,
          sum_blocks*dt.block_size/1024/1024 usage_mb
FROM      (
          SELECT username, sqladdr, sqlhash, sql_id, tablespace, segtype, session_addr,
          SUM(blocks) sum_blocks
          FROM v$tempseg_usage
	        GROUP BY  username, sqladdr, sqlhash, sql_id, tablespace, segtype,session_addr
          ) "VSU",
          v$sqltext vst,
          v$session vs,
          v$process vp,
          dba_tablespaces dt
WHERE     vs.sql_id = vst.sql_id
AND       vsu.session_addr = vs.saddr
AND       vs.paddr = vp.addr
AND       vst.piece = 0
AND       vs.status='ACTIVE'
AND       dt.tablespace_name = vsu.tablespace
ORDER BY  usage_mb;

SELECT    s.sid ||','|| s.serial# sid_serial, s.username, q.sql_id, t.blocks * tbs.block_size / 1024 / 1024 mb_used, t.tablespace
FROM      v$tempseg_usage t, v$session s, v$sqlarea q, dba_tablespaces tbs
WHERE     t.session_addr = s.saddr
AND       t.sqladdr = q.address
AND       t.tablespace = tbs.tablespace_name
ORDER BY  mb_used;

BREAK ON snap_id SKIP 1
SELECT    snap_id,
          instance_number,
          end_time,
          ROUND(TEMP_SPACE_USED, 2) "TEMP_SPACE_USED"
FROM      (
          SELECT  snap_id,
                  instance_number,
                  end_time,
                  metric_name,
                  maxval
          FROM    dba_hist_sysmetric_summary
          WHERE   end_time >= SYSDATE - INTERVAL '&days' day
          AND     REGEXP_LIKE(instance_number, '&instance_number')
          )
PIVOT     (
          MAX(maxval)
          FOR metric_name IN ('Temp Space Used' AS TEMP_SPACE_USED)
          )
ORDER BY  snap_id;

COLUMN sample_time FORMAT a30
SELECT      sample_time,
            session_id,
            session_serial#,
            sql_id,
            sql_plan_hash_value,
            temp_space_allocated/1024/1024 temp_mb,
            temp_space_allocated/1024/1024 - LAG(temp_space_allocated/1024/1024,1,0) OVER (ORDER BY sample_time) AS temp_diff
FROM        v$active_session_history
WHERE       sample_time > TO_DATE('&&start_datetime','DDMMRRHH24MI')
AND         sample_time < TO_DATE('&&end_datetime','DDMMRRHH24MI')
AND         temp_space_allocated/1024/1024 > 100
ORDER BY    temp_mb ASC
/

COLUMN sample_time FORMAT a30
SELECT      sample_time,
            session_id,
            session_serial#,
            sql_id,
            sql_plan_hash_value,
            temp_space_allocated/1024/1024 temp_mb,
            temp_space_allocated/1024/1024 - LAG(temp_space_allocated/1024/1024,1,0) OVER (ORDER BY sample_time) AS temp_diff
FROM        dba_hist_active_sess_history
WHERE       snap_id BETWEEN &&begin_snap AND &&end_snap
AND         temp_space_allocated/1024/1024 > 100
ORDER BY    temp_mb ASC
/

COLUMN sample_time FORMAT a30
SELECT      sample_time,
            session_id,
            session_serial#,
            machine,
            temp_space_allocated/1024/1024 temp_mb,
            temp_space_allocated/1024/1024 - LAG(temp_space_allocated/1024/1024,1,0) OVER (ORDER BY sample_time) AS temp_diff
FROM        v$active_session_history
WHERE       sample_time > TO_DATE('&&start_datetime','DDMMRRHH24MI')
AND         sample_time < TO_DATE('&&end_datetime','DDMMRRHH24MI')
AND         sql_id = '&sql_id'
AND         temp_space_allocated/1024/1024 > 100
ORDER BY    temp_mb ASC
/

COLUMN sample_time FORMAT a30
SELECT      sample_time,
            session_id,
            session_serial#,
            machine,
            temp_space_allocated/1024/1024 temp_mb,
            temp_space_allocated/1024/1024 - LAG(temp_space_allocated/1024/1024,1,0) OVER (ORDER BY sample_time) AS temp_diff
FROM        dba_hist_active_sess_history
WHERE       snap_id BETWEEN &&begin_snap AND &&end_snap
AND         sql_id = '&sql_id'
AND         temp_space_allocated/1024/1024 > 100
ORDER BY    temp_mb ASC
/