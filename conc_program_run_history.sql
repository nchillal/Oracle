set linesize 220
col progName format a39
col logfile_name format a55 word_wrap
col argument_text format a30
col "Total Run Time" for a30

select  	request_id,
        	p.user_concurrent_program_name progName,
        	argument_text,
        	r.logfile_name,
        	EXTRACT(DAY FROM (actual_completion_date - actual_start_date) DAY TO SECOND )
  			|| ' days '
  			|| EXTRACT(HOUR FROM (actual_completion_date - actual_start_date) DAY TO SECOND )
  			|| ' hours '
  			|| EXTRACT(MINUTE FROM (actual_completion_date - actual_start_date) DAY TO SECOND )
  			|| ' minutes' "Total Run Time"
FROM    	applsys.fnd_concurrent_requests r, apps.fnd_concurrent_programs_tl p
WHERE   	p.concurrent_program_id = r.concurrent_program_id
and     	r.phase_code='C'
and     	r.status_code='C'
and     	p.user_concurrent_program_name = '&ucpn'
ORDER BY 	1
/
