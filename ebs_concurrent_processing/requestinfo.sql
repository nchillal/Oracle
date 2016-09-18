set linesize 200

SELECT  request_id,
        oracle_process_id,
        phase_code,
        status_code,
        TO_CHAR(request_date,'DD-MON-YYYY HH24:MI:SS') "Submitted", 
        TO_CHAR(actual_start_date,'DD-MON-YYYY HH24:MI:SS') "Started",
        TO_CHAR(actual_completion_date,'DD-MON-YYYY HH24:MI:SS') "Completed" 
FROM    apps.fnd_concurrent_requests 
where   request_id in ('&requestid');

