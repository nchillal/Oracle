prompt
accept request prompt 'Please enter the concurrent request id for the appropriate concurrent program:'
prompt

column traceid format a8
column tracename format a80
column user_concurrent_program_name format a40
column execname format a15
column enable_trace format a12
set linesize 80
set pagesize 22
set head off

SELECT  'Request id: '||request_id ,
        'Trace id: '||oracle_Process_id,
        'Trace Flag: '||req.enable_trace,
        'Trace Name: '||dest.value||'/'||LOWER(dbnm.value)||'_ora_'||oracle_process_id||'.trc',
        'Prog. Name: '||prog.user_concurrent_program_name,
        'File Name: '||execname.execution_file_name|| execname.subroutine_name ,
        'Status : '||DECODE(phase_code,'R','Running')
        ||'-'||DECODE(status_code,'R','Normal'),
        'SID Serial: '||ses.sid||','|| ses.serial#,
        'Module : '||ses.module
FROM    apps.fnd_concurrent_requests req,
        v$session ses,
        v$process proc,
        v$parameter dest,
        v$parameter dbnm,
        apps.fnd_concurrent_programs_vl prog,
        apps.fnd_executables execname
where   req.request_id = &request
and     req.oracle_process_id=proc.spid(+)
and     proc.addr = ses.paddr(+)
and     dest.name='user_dump_dest'
and     dbnm.name='db_name'
and     req.concurrent_program_id = prog.concurrent_program_id
and     req.program_application_id = prog.application_id
--- and prog.application_id = execname.application_id
and     prog.executable_application_id = execname.application_id
and     prog.executable_id=execname.executable_id; 
