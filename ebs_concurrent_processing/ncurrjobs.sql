SET PAGESIZE 66 LINESIZE 172
COLUMN  ProgName FORMAT a55 WORD_WRAPPED
COLUMN  user_name FORMAT a20 WORD_WRAPPED
COLUMN  requestId FORMAT 99999999
COLUMN  oracle_process_id FORMAT a8
COLUMN  os_process_id FORMAT a8
COLUMN  StartDate FORMAT a15 WORD_wRAPPED
SELECT    sess.inst_id, fcp.user_concurrent_program_name progName,
          SUBSTR(fusr.description,1,19) user_name,
          TO_CHAR(actual_Start_date,'DD-MON HH24:MI:SS') StartDate,
          request_id RequestId,
          fcr.oracle_process_id,
          NVL(fcr.os_process_id,fcpp.os_process_id) os_process_id ,
          sess.sid,
          (SYSDATE - actual_start_date)*24*60*60 ElapseTime
 FROM     apps.fnd_concurrent_requests fcr,
          apps.fnd_concurrent_programs_tl  fcp,
          apps.fnd_user fusr,
          gv$session sess,
          apps.fnd_concurrent_processes fcpp
where     fcp.concurrent_program_id = fcr.concurrent_program_id
AND       fcr.program_application_id = fcp.application_id
AND       fcp.language = 'US'
AND       fcr.phase_code IN ('R')
AND       fcr.status_code IN ('R','T')
AND       fcr.requested_by = fusr.user_id
AND       sess.process(+) = fcr.os_process_id
and       fcr.controlling_manager = fcpp.concurrent_process_id
ORDER BY  &1 DESC
/
