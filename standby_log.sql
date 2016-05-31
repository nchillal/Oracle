select inst_id, thread#, GROUP#, bytes/1024/1024, status from gv$standby_log;

set lines 230 pages 200
col member for a70
select inst_id, group#,  member, status from gv$logfile where type='STANDBY';
