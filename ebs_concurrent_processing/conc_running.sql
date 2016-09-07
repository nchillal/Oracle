set pages 66
set feed on
set line 200
COLUMN  user_name FORMAT a40 word_wrapped
COLUMN	ProgName	FORMAT a55 word_wrapped
COLUMN  requestId	FORMAT 99999999999
COLUMN  StartDate	FORMAT a20 word_Wrapped
COLUMN  SERVER    FORMAT a6
COLUMN  CLIENT    FORMAT a6
COLUMN  ETime     FORMAT 999999 word_Wrapped
COLUMN  sid       FORMAT 99999 word_Wrapped

SELECT    sess.sid,
          oracle_process_id SERVER,
          os_process_id CLIENT,
          fusr.description user_name,
          fcp.user_concurrent_program_name progName,
          TO_CHAR(actual_Start_date,'DD-MON-YYYY HH24:MI:SS') StartDate,
          request_id	RequestId,
          (SYSDATE - actual_start_date)*24*60*60 ETime
FROM 	    apps.fnd_concurrent_requests fcr,
          apps.fnd_concurrent_programs_tl fcp,
          apps.fnd_user fusr,
          gv$session sess
WHERE     fcp.concurrent_program_id = fcr.concurrent_program_id
AND       fcr.program_application_id	= fcp.application_id
AND       fcp.language		= 'US'
AND       fcr.phase_code	= 'R'
AND       fcr.status_code	= 'R'
AND       fcr.requested_by = fusr.user_id
AND       fcr.oracle_session_id = sess.audsid (+)
AND       fcr.oracle_session_id IS NOT NULL
UNION
SELECT    sess.sid,
          proc.spid SERVER,
          fcpr.os_process_id CLIENT,
          fusr.description user_name,
          fcp.user_concurrent_program_name	progName,
          TO_CHAR(actual_Start_date,'DD-MON-YYYY HH24:MI:SS') StartDate,
          request_id	RequestId,
          (SYSDATE - actual_start_date)*24*60*60 ETime
FROM 	    apps.fnd_concurrent_requests fcr,
          apps.fnd_concurrent_programs_tl fcp,
          apps.fnd_concurrent_processes fcpr,
          apps.fnd_user fusr,
          gv$session sess,
          gv$process proc
WHERE     fcp.concurrent_program_id = fcr.concurrent_program_id
AND       fcr.program_application_id	= fcp.application_id
AND       fcp.language		= 'US'
AND       fcr.phase_code	= 'R'
AND       fcr.status_code	= 'R'
AND       fcr.requested_by = fusr.user_id
AND       fcr.controlling_manager=fcpr.concurrent_process_id
AND       fcpr.session_id = sess.audsid
AND       fcr.oracle_process_id IS NULL
AND       proc.addr=sess.paddr
order by  6,4,8
/
