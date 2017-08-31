COLUMN username FORMAT a12
COLUMN username FORMAT a12
COLUMN "QC SID" FORMAT 999999
COLUMN sid FORMAT 999999
COLUMN "QC/Slave" FORMAT A8
COLUMN "Requested DOP" FORMAT 9999
COLUMN "Actual DOP" FORMAT 9999
COLUMN "Slaveset" FORMAT 999999
COLUMN "Slave INST" FORMAT 999999
COLUMN "QC INST" FORMAT 9999
COLUMN "SPID" FORMAT A6
SET PAGESIZE 300
SET LINESIZE 200
SELECT    s.logon_time "Logon Time",
          DECODE(px.qcinst_id,NULL,username,' - '||LOWER(SUBSTR(pp.server_name, LENGTH(pp.server_name)-4,4) ) )"Username",
          DECODE(px.qcinst_id,NULL, 'QC', 'Slave') "QC/Slave" ,
          s.status "Status",
          px.qcinst_id "QC INST",
          px.inst_id "Slave INST",
          decode(px.qcinst_id, NULL, s.sid, px.qcsid) "QC SID",
          s.sid "SID",
          pp.spid "SPID",
          px.req_degree "Req. DOP",
          px.degree "Actual DOP",
          s.sql_id "SQL_ID",
          s.sql_child_number "Child Number"
FROM      gv$px_session px, gv$session s, gv$px_process pp
where     px.sid=s.sid (+)
AND       px.serial#=s.serial#(+)
AND       px.inst_id = s.inst_id(+)
AND       px.sid = pp.sid (+)
AND       px.serial#=pp.serial#(+)
ORDER BY  3
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
