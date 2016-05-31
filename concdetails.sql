set pages 100
set verify off
set echo off
set linesize 200
prompt Enter concurrent program name in full or part in correct case
prompt
accept prg_nm prompt 'PROGRAM_NAME->'
prompt
column request_id format 99999999
col argument_text for a50
column name format a50
break on NAME on USER_NM
--break on USER_NM skip 1
column ex_time format 999999.99
column user_nm format a10
alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS'
/
select b.user_concurrent_program_name NAME,c.user_name USER_NM,a.request_id,(a.actual_completion_date-a.actual_start_date)*24*60 "EX_TIME",ARGUMENT_TEXT,
       a.actual_start_date "START_DT",a.actual_completion_date "COMPLETION_DT"
from apps.fnd_concurrent_requests a, apps.fnd_concurrent_programs_tl b, apps.fnd_user c
where a.concurrent_program_id=b.concurrent_program_id
and b.user_concurrent_program_name ='&prg_nm'
and trunc(a.actual_start_date) > sysdate - 46
and a.requested_by=c.user_id
order by a.actual_start_date
/
