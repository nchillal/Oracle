set pages 66
set feed on
set line 200
column  user_name format a40 word_wrapped
column	ProgName	format a55 word_wrapped
column  requestId	format 99999999999
column  StartDate	format a20 word_Wrapped
column  SERVER    format a6
column  CLIENT    format a6
column  ETime     format 999999 word_Wrapped
column  sid       format 99999 word_Wrapped

select  sess.sid, oracle_process_id SERVER, os_process_id CLIENT, fusr.description user_name, fcp.user_concurrent_program_name progName, to_char(actual_Start_date,'DD-MON-YYYY HH24:MI:SS') StartDate, request_id	RequestId, (sysdate - actual_start_date)*24*60*60 ETime
from 	apps.fnd_concurrent_requests fcr, apps.fnd_concurrent_programs_tl  fcp, apps.fnd_user fusr, gv$session sess
where fcp.concurrent_program_id = fcr.concurrent_program_id
and fcr.program_application_id	= fcp.application_id
and fcp.language		= 'US'
and fcr.phase_code	= 'R'
and fcr.status_code	= 'R'
and fcr.requested_by = fusr.user_id
and fcr.oracle_session_id = sess.audsid (+)
and fcr.oracle_session_id is not null
UNION
select  sess.sid, proc.spid SERVER, fcpr.os_process_id CLIENT, fusr.description user_name, fcp.user_concurrent_program_name		progName, to_char(actual_Start_date,'DD-MON-YYYY HH24:MI:SS') StartDate, request_id	RequestId, (sysdate - actual_start_date)*24*60*60 ETime
from 	apps.fnd_concurrent_requests fcr, apps.fnd_concurrent_programs_tl  fcp, apps.fnd_concurrent_processes fcpr, apps.fnd_user fusr, gv$session sess, gv$process proc
where fcp.concurrent_program_id = fcr.concurrent_program_id
and fcr.program_application_id	= fcp.application_id
and fcp.language		= 'US'
and fcr.phase_code	= 'R'
and fcr.status_code	= 'R'
and fcr.requested_by = fusr.user_id
and fcr.controlling_manager=fcpr.concurrent_process_id
and fcpr.session_id = sess.audsid
and fcr.oracle_process_id is null
and proc.addr=sess.paddr
order by 6,4,8
/
