col username for a12
col username for a12
col "QC SID" for A6
col SID for A6
col "QC/Slave" for A8
col "Requested DOP" for 9999
col "Actual DOP" for 9999
col "Slaveset" for A8
col "Slave INST" for A9
col "QC INST" for A6
set pagesize 300
set linesize 200 
SELECT
decode(px.qcinst_id,NULL,username, 
' - '||lower(substr(pp.SERVER_NAME,
length(pp.SERVER_NAME)-4,4) ) )"Username",
decode(px.qcinst_id,NULL, 'QC', '(Slave)') "QC/Slave" ,
to_char( px.server_set) "SlaveSet",
to_char(s.sid) "SID",
to_char(px.inst_id) "Slave INST",
decode(px.qcinst_id, NULL ,to_char(s.sid) ,px.qcsid) "QC SID",
to_char(px.qcinst_id) "QC INST",
px.req_degree "Req. DOP",
px.degree "Actual DOP"
FROM gv$px_session px,
gv$session s ,
gv$px_process pp
where px.sid=s.sid (+)
and px.serial#=s.serial#(+)
and px.inst_id = s.inst_id(+)
and px.sid = pp.sid (+)
and px.serial#=pp.serial#(+)
ORDER BY 6 , 1 desc
/

clear columns 
col "Wait Event" for a50
SELECT px.SID "SID", p.PID, p.SPID "SPID", px.INST_ID "Inst",
       px.SERVER_GROUP "Group", px.SERVER_SET "Set",
       px.DEGREE "Degree", px.REQ_DEGREE "Req Degree", w.event "Wait Event"
FROM GV$SESSION s, GV$PX_SESSION px, GV$PROCESS p, GV$SESSION_WAIT w
WHERE s.sid (+) = px.sid AND s.inst_id (+) = px.inst_id AND
      s.sid = w.sid (+) AND s.inst_id = w.inst_id (+) AND
      s.paddr = p.addr (+) AND s.inst_id = p.inst_id (+)
ORDER BY DECODE(px.QCINST_ID,  NULL, px.INST_ID,  px.QCINST_ID), px.QCSID, 
DECODE(px.SERVER_GROUP, NULL, 0, px.SERVER_GROUP), px.SERVER_SET, px.INST_ID;

