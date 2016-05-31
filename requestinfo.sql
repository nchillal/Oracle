set linesize 200

select request_id,oracle_process_id,phase_code,status_code,
to_char(request_date,'DD-MON-YYYY HH24:MI:SS') "Submitted", to_char(actual_start_date,'DD-MON-YYYY HH24:MI:SS') "Started",to_char(actual_completion_date,'DD-MON-YYYY HH24:MI:SS') "Completed" from apps.fnd_concurrent_requests where request_id in ('&requestid');

