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
prompt
prompt #####################################################################
prompt #######################LOCAL TEMP USAGE#############################
prompt #####################################################################
prompt
SELECT    A.tablespace_name tablespace, D.mb_total,
          SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
          D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free
FROM      v$sort_segment A,
(
SELECT    B.name, C.block_size, SUM (C.bytes) / 1024 / 1024 mb_total
FROM      v$tablespace B, v$tempfile C
WHERE     B.ts#= C.ts#
GROUP BY  B.name, C.block_size
) D
WHERE     A.tablespace_name = D.name
GROUP BY  A.tablespace_name, D.mb_total;
prompt
prompt #####################################################################
prompt #######################LOCAL TEMP USERS#############################
prompt #####################################################################
prompt
SELECT    S.sid || ',' || S.serial# sid_serial, S.username, S.osuser, P.spid, S.module, P.program, s.service_name,
          SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
          COUNT(*) statements
FROM      v$tempseg_usage T, v$session S, dba_tablespaces TBS, v$process P
WHERE     T.session_addr = S.saddr
AND       S.paddr = P.addr
AND       T.tablespace = TBS.tablespace_name
GROUP BY  S.sid, S.serial#, S.username, S.osuser, P.spid, S.module, P.program, s.service_name, TBS.block_size, T.tablespace
ORDER BY  mb_used;
prompt
prompt #####################################################################
prompt #######################LOCAL ACTIVE SQLS ############################
prompt #####################################################################
prompt
SELECT    sysdate "TIME_STAMP",
          vsu.username,
          vs.sid,
          vp.spid,
          vs.sql_id,
          vst.sql_text,
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
prompt
prompt #####################################################################
prompt #######################LOCAL TEMP SQLS##############################
prompt #####################################################################
prompt
SELECT    s.sid ||','|| s.serial# sid_serial, s.username, q.sql_id, q.sql_text, t.blocks * TBS.block_size / 1024 / 1024 mb_used, t.tablespace
FROM      v$tempseg_usage t, v$session s, v$sqlarea q, dba_tablespaces tbs
WHERE     t.session_addr = s.saddr
AND       t.sqladdr = q.address
AND       t.tablespace = tbs.tablespace_name
ORDER BY  mb_used;
