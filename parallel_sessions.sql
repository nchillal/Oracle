COLUMN username FORMAT a12
COLUMN username FORMAT a12
COLUMN "QC SID" FORMAT A6
COLUMN sid FORMAT A6
COLUMN "QC/Slave" FORMAT A8
COLUMN "Requested DOP" FORMAT 9999
COLUMN "Actual DOP" FORMAT 9999
COLUMN "Slaveset" FORMAT A8
COLUMN "Slave INST" FORMAT A9
COLUMN "QC INST" FORMAT A6
set pagesize 300
set linesize 200
SELECT    DECODE(px.qcinst_id,NULL,username,' - '||LOWER(SUBSTR(pp.server_name, LENGTH(pp.server_name)-4,4) ) )"Username",
          DECODE(px.qcinst_id,NULL, 'QC', '(Slave)') "QC/Slave" ,
          TO_CHAR( px.server_set) "SlaveSet",
          TO_CHAR(s.sid) "SID",
          TO_CHAR(px.inst_id) "Slave INST",
          decode(px.qcinst_id, NULL, TO_CHAR(s.sid), px.qcsid) "QC SID",
          TO_CHAR(px.qcinst_id) "QC INST",
          px.req_degree "Req. DOP",
          px.degree "Actual DOP"
FROM      gv$px_session px, gv$session s, gv$px_process pp
where     px.sid=s.sid (+)
AND       px.serial#=s.serial#(+)
AND       px.inst_id = s.inst_id(+)
AND       px.sid = pp.sid (+)
AND       px.serial#=pp.serial#(+)
ORDER BY  6, 1 DESC
/

CLEAR COLUMNS
COLUMN "Wait Event" FORMAT a50
SELECT    px.sid "SID", p.pid, p.spid "SPID", px.inst_id "Inst",
          px.server_group "Group", px.server_set "Set",
          px.degree "Degree", px.req_degree "Req Degree", w.event "Wait Event"
FROM      gv$session s, gv$px_session px, gv$process p, gv$session_wait w
WHERE     s.sid (+) = px.sid
AND       s.inst_id (+) = px.inst_id
AND       s.sid = w.sid (+)
AND       s.inst_id = w.inst_id (+)
AND       s.paddr = p.addr (+)
AND       s.inst_id = p.inst_id (+)
ORDER BY  DECODE(px.qcinst_id,  NULL, px.inst_id,  px.qcinst_id),
          px.qcsid,
          DECODE(px.server_group, NULL, 0, px.server_group),
          px.server_set,
          px.inst_id;
