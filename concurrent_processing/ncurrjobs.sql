set pages 66
set line 172
column  ProgName        format a55 word_wrapped
column  user_name         format a20 word_wrapped
column  requestId       format 99999999
column  oracle_process_id       format a8
column  os_process_id   format a8
column  StartDate       format a15 word_Wrapped
select
                sess.inst_id, fcp.user_concurrent_program_name                progName,
                substr(fusr.description,1,19) user_name ,
                to_char(actual_Start_date,'DD-MON HH24:MI:SS') StartDate,
                request_id                                                                                      RequestId,
                fcr.oracle_process_id,
                nvl(fcr.os_process_id,fcpp.os_process_id) os_process_id ,
                sess.sid,
                (sysdate - actual_start_date)*24*60*60 ElapseTime
 from   apps.fnd_concurrent_requests fcr,
                apps.fnd_concurrent_programs_tl  fcp,
        apps.fnd_user fusr,
                gv$session sess,
        apps.fnd_concurrent_processes fcpp
where fcp.concurrent_program_id = fcr.concurrent_program_id
  and fcr.program_application_id        = fcp.application_id
  and fcp.language              = 'US'
  and fcr.phase_code    in ('R')
  and fcr.status_code   in ('R','T')
  and fcr.requested_by = fusr.user_id
  and sess.process(+)=fcr.os_process_id
  and fcr.controlling_manager=fcpp.concurrent_process_id
 order by &1 DESC
/
