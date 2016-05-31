set verify off
set linesize 200
col progName format a39
col user_name format a20
col logfile_name format a41 word_wrap
col start format a18
col end format a18
col argument_text format a30
select request_id,user_name,p.user_concurrent_program_name progName,argument_text,  phase_code,status_code,r.logfile_name, to_char(actual_start_date,'DD-MON-YY HH24:MI:SS') "Start",to_char(actual_completion_date,'DD-MON-YY HH24:MI:SS') "End" from applsys.fnd_concurrent_requests r,apps.fnd_user u,apps.fnd_concurrent_programs_tl p, gv$session s where  request_id = &reqid and p.concurrent_program_id = r.concurrent_program_id and r.requested_by=u.user_id and r.oracle_session_id = s.audsid(+)
/

