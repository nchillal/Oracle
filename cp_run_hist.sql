set linesize 220
COLUMN progName FORMAT a39
COLUMN logfile_name FORMAT a55 word_wrap
COLUMN argument_text FORMAT a30
COLUMN "Total Run Time" FORMAT a30

SELECT    request_id,
          p.user_concurrent_program_name progName,
        	argument_text,
        	r.logfile_name,
        	EXTRACT(DAY FROM (actual_completion_date - actual_start_date) DAY TO SECOND ) || ' days ' || 
        	EXTRACT(HOUR FROM (actual_completion_date - actual_start_date) DAY TO SECOND ) || ' hours ' || 
        	EXTRACT(MINUTE FROM (actual_completion_date - actual_start_date) DAY TO SECOND ) || ' minutes' "Total Run Time"
FROM    	applsys.fnd_concurrent_requests r, apps.fnd_concurrent_programs_tl p
WHERE   	p.concurrent_program_id = r.concurrent_program_id
AND     	r.phase_code='C'
AND     	r.status_code='C'
AND     	p.user_concurrent_program_name = '&ucpn'
ORDER BY 	1
/
