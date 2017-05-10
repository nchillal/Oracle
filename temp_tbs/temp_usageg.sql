COLUMN sid_serial FORMAT a10
COLUMN username FORMAT a17
COLUMN osuser FORMAT a15
COLUMN module FORMAT a15
COLUMN pid FORMAT 999999
COLUMN program FORMAT a30
COLUMN service_name FORMAT a15
COLUMN mb_used FORMAT 999999.999
COLUMN mb_total FORMAT 999999.999
COLUMN tablespace FORMAT a15
COLUMN statements FORMAT 999
COLUMN hash_value FORMAT 99999999999
COLUMN sql_text FORMAT a50

PROMPT
PROMPT #####################################################################
PROMPT #######################GLOBAL TEMP USAGE#############################
PROMPT #####################################################################
PROMPT

SELECT    a.inst_id,
          a.tablespace_name tablespace,
          d.mb_total,
          SUM(A.used_blocks * D.block_size)/1024/1024 mb_used,
          D.mb_total - SUM(A.used_blocks * D.block_size)/1024/1024 mb_free
FROM      gv$sort_segment A,
          (
          SELECT    b.inst_id,b.name,
                    c.block_size,
                    SUM(c.bytes)/1024/1024 mb_total
          FROM      gv$tablespace b, gv$tempfile c
          WHERE     b.ts#= c.ts#
          AND       c.inst_id = b.inst_id
          GROUP BY  b.inst_id, b.name, c.block_size
          ) D
WHERE     a.tablespace_name = d.name
AND       a.inst_id=d.inst_id
GROUP BY  a.inst_id, a.tablespace_name, d.mb_total;

PROMPT
PROMPT #####################################################################
PROMPT #######################GLOBAL TEMP USERS#############################
PROMPT #####################################################################
PROMPT

SELECT    s.inst_id,
          s.sid||','||s.serial# sid_serial,
          s.username,
          s.osuser,
          p.spid PID,
          s.service_name,
          s.module,
          p.program,
          t.segtype,
          SUM(T.blocks)*TBS.block_size/1024/1024 mb_used, t.tablespace,
          COUNT(*) statements
FROM      gv$tempseg_usage t, gv$session s, dba_tablespaces tbs, gv$process p
WHERE     t.session_addr = s.saddr
AND       s.paddr = p.addr
AND	      s.inst_id = p.inst_id
AND	      t.inst_id = p.inst_id
AND	      s.inst_id = t.inst_id
AND       t.tablespace = tbs.tablespace_name
HAVING    SUM(T.blocks)*tbs.block_size/1024/1024 > 10
GROUP BY  s.inst_id,
          S.sid,
          S.serial#, S.username,
          S.osuser, P.spid,
          S.Service_name,
          S.module,
          P.program,
          TBS.block_size, T.tablespace,segtype
ORDER BY  mb_used;

PROMPT
PROMPT #####################################################################
PROMPT #######################GLOBAL ACTIVE SQLS ###########################
PROMPT #####################################################################
PROMPT

SELECT    SYSDATE "TIME_STAMP",
          vs.inst_id,
          vsu.username,
          vs.sid,
          vp.spid,
          vs.sql_id,
          vst.sql_text,
          vsu.segtype,
          vsu.tablespace,
          sum_blocks*dt.block_size/1024/1024 usage_mb
FROM      (
          SELECT    inst_id,
                    username,
                    sqladdr,
                    sqlhash,
                    sql_id,
                    segtype,
                    tablespace,
                    session_addr,
                    SUM(blocks) sum_blocks
          FROM      gv$tempseg_usage
          GROUP BY  inst_id,username,
                    sqladdr,
                    sqlhash,
                    sql_id,
                    segtype,
                    tablespace,
                    session_addr
          ) "VSU",
          gv$sqltext vst,
          gv$session vs,
          gv$process vp,
          dba_tablespaces dt
WHERE     vs.sql_id = vst.sql_id
AND       vsu.session_addr = vs.saddr
AND       vsu.inst_id = vst.inst_id
and       vs.inst_id = vsu.inst_id
and       vp.inst_id = vs.inst_id
and       vp.inst_id = vsu.inst_id
and       vp.inst_id = vst.inst_id
AND       vs.paddr = vp.addr
AND       vst.piece = 0
AND       vs.status = 'ACTIVE'
AND       dt.tablespace_name = vsu.tablespace
ORDER BY  usage_mb;

PROMPT
PROMPT #####################################################################
PROMPT #######################GLOBAL TEMP SQLS##############################
PROMPT #####################################################################
PROMPT

SELECT    s.inst_id,
          s.sid || ',' || s.serial# sid_serial,
          s.username,
          q.hash_value,
          q.sql_text,
          t.blocks * TBS.block_size/1024/1024 mb_used,
          t.tablespace
FROM      gv$tempseg_usage t, gv$session s, gv$sqlarea q, dba_tablespaces tbs
WHERE     t.session_addr = s.saddr
AND       t.inst_id = s.inst_id
AND       q.inst_id = s.inst_id
AND       t.inst_id = q.inst_id
AND       t.sqladdr = q.address
AND       t.tablespace = tbs.tablespace_name
AND       t.blocks * tbs.block_size/1024/1024 > 10
ORDER BY  mb_used;
