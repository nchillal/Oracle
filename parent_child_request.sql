COLUMN "Program Name" FORMAT A37
COLUMN "Delay" FORMAT 9999.99
COLUMN "Elapsed" FORMAT 9999.99
SELECT    /*+ ORDERED USE_NL(x fcr fcp fcptl)*/
          fcr.request_id "Request ID",
          fcptl.user_concurrent_program_name"Program Name",
          fcr.phase_code,
          fcr.status_code,
          TO_CHAR(fcr.request_date,'DD-MON-YYYY HH24:MI:SS') "Submitted",
          (fcr.actual_start_date - fcr.request_date)*1440 "Delay",
          TO_CHAR(fcr.actual_start_date,'DD-MON-YYYY HH24:MI:SS') "Start Time",
          TO_CHAR(fcr.actual_completion_date, 'DD-MON-YYYY HH24:MI:SS') "End Time",
          (fcr.actual_completion_date - fcr.actual_start_date)*1440 "Elapsed",
          fcr.oracle_process_id "Trace ID"
FROM      ( SELECT       /*+ index (fcr1 fnd_concurrent_requests_n3) */
                      fcr1.request_id
            FROM        apps.fnd_concurrent_requests fcr1
            WHERE       1=1
            START WITH  fcr1.request_id = &parent_request_id
            CONNECT BY  PRIOR fcr1.request_id = fcr1.parent_request_id
          )x,
          apps.fnd_concurrent_requests fcr,
          apps.fnd_concurrent_programs fcp,
          apps.fnd_concurrent_programs_tl fcptl
WHERE     fcr.request_id = x.request_id
AND       fcr.concurrent_program_id = fcp.concurrent_program_id
AND       fcr.program_application_id = fcp.application_id
AND       fcp.application_id = fcptl.application_id
AND       fcp.concurrent_program_id = fcptl.concurrent_program_id
AND       fcptl.language = 'US'
ORDER BY 1;
