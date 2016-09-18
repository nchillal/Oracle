set linesize 200 numwidth 20
COLUMN host_name FORMAT a40
COLUMN open_mode FORMAT a10

ALTER SESSION SET NLS_DATE_FORMAT='DD_MON-YYYY HH24:MI:SS';

show parameter service

SELECT    instance_name,
          startup_time,
          host_name,
          status,
          active_state,
          database_status,
          logins
FROM      gv$instance;

SELECT    name,
          open_mode,
          database_role,
          log_mode,
          checkpoint_change#,
          controlfile_type,
          protection_mode,
          protection_level,
          switchover_status,
          dataguard_broker "DGMGRL"
FROM      v$database;
