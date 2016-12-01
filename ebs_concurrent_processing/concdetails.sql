set pagesize 100
set verify off
set echo off
set linesize 200
prompt Enter concurrent program name in full or part in correct case
prompt
accept prg_nm prompt 'PROGRAM_NAME->'
prompt
COLUMN request_id FORMAT 99999999
COLUMN argument_text FORMAT a50
COLUMN name FORMAT a50
BREAK ON NAME ON USER_NM
COLUMN ex_time FORMAT 999999.99
COLUMN user_nm FORMAT a10

ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS'
/

SELECT    b.user_concurrent_program_name NAME,
          c.user_name USER_NM,
          a.request_id,
          (a.actual_completion_date - a.actual_start_date)*24*60 "EX_TIME",
          argument_text,
          a.actual_start_date "START_DT",
          a.actual_completion_date "COMPLETION_DT"
FROM      apps.fnd_concurrent_requests a,
          apps.fnd_concurrent_programs_tl b,
          apps.fnd_user c
where     a.concurrent_program_id=b.concurrent_program_id
and       b.user_concurrent_program_name ='&prg_nm'
and       TRUNC(a.actual_start_date) > SYSDATE - 46
and       a.requested_by=c.user_id
ORDER BY  a.actual_start_date
/
