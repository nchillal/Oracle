-- List baselines for SQL_ID.
SELECT  TO_CHAR(created, 'DD-MON-RR HH24:MI:SS') CREATED,
        TO_CHAR(last_modified, 'DD-MON-RR HH24:MI:SS') LAST_MODIFIED,
        TO_CHAR(last_executed, 'DD-MON-RR HH24:MI:SS') LAST_EXECUTED,
        sql_handle,
        plan_name,
        enabled,
        accepted,
        fixed
FROM    dba_sql_plan_baselines
WHERE   signature IN (SELECT exact_matching_signature FROM v$sql WHERE sql_id='&SQL_ID');