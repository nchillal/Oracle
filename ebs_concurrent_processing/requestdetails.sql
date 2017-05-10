SET VERIFY OFF LINESIZE 200

COLUMN progName FORMAT a39
COLUMN user_name FORMAT a20
COLUMN logfile_name FORMAT a41 WORD_WRAP
COLUMN start FORMAT a18
COLUMN end FORMAT a18
COLUMN argument_text FORMAT a30

SELECT  request_id,
        user_name,
        p.user_concurrent_program_name progName,
        argument_text,
        phase_code,
        status_code,
        r.logfile_name,
        TO_CHAR(actual_start_date,'DD-MON-YY HH24:MI:SS') "Start",
        TO_CHAR(actual_completion_date,'DD-MON-YY HH24:MI:SS') "End"
FROM    applsys.fnd_concurrent_requests r, apps.fnd_user u, apps.fnd_concurrent_programs_tl p, gv$session s
WHERE   request_id = &reqid
AND     p.concurrent_program_id = r.concurrent_program_id
AND     r.requested_by=u.user_id
AND     r.oracle_session_id = s.audsid(+)
/
