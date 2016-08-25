set lines 200
COLUMN host_name FORMAT a40

ALTER SESSION SET NLS_DATE_FORMAT='DD_MON-YYYY HH24:MI:SS';

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
          database_role
FROM      v$database;
