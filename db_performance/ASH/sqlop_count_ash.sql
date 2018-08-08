BREAK ON username SKIP 1
COMPUTE SUM LABEL "Total => " OF INSRT ON username
COMPUTE SUM LABEL "Total => " OF UPD ON username
COMPUTE SUM LABEL "Total => " OF DLT ON username
COMPUTE SUM LABEL "Total => " OF SLT ON username

SELECT    *
FROM      (
          SELECT    username, TO_CHAR(sample_time, 'DDMMRRHH24MI') "DAY_HOUR", sql_opname
          FROM      v$active_session_history ash, dba_users du
          WHERE     ash.user_id = du.user_id
          AND       sample_time > SYSDATE - INTERVAL '&minutes' MINUTE
          )
PIVOT     (
          COUNT(sql_opname)
          FOR sql_opname IN ('INSERT' as INSRT, 'UPDATE' as UPD, 'DELETE' as DLT, 'SELECT' as SLT, 'UPSERT'as UPSRT, 'ALTER TABLE' as AT, 'CREATE TABLE' as CT, 'TRUNCATE TABLE' as TT, 'DROP TABLE' as DT, 'PL/SQL EXECUTE' as PLSQL, 'REVOKE OBJECT' as REV, 'ALTER DATABASE' as AD, 'EXPLAIN' as EP)
          )
ORDER BY  username, day_hour;

BREAK ON day_hour SKIP 1
COMPUTE SUM LABEL "Total => " OF INSRT ON day_hour
COMPUTE SUM LABEL "Total => " OF UPD ON day_hour
COMPUTE SUM LABEL "Total => " OF DLT ON day_hour
COMPUTE SUM LABEL "Total => " OF SLT ON day_hour

SELECT    *
FROM      (
          SELECT    username, TO_CHAR(sample_time, 'DDMMRRHH24MI') "DAY_HOUR", sql_opname
          FROM      v$active_session_history ash, dba_users du
          WHERE     ash.user_id = du.user_id
          AND       sample_time > SYSDATE - INTERVAL '&minutes' MINUTE
          )
PIVOT     (
          COUNT(sql_opname)
          FOR sql_opname IN ('INSERT' as INSRT, 'UPDATE' as UPD, 'DELETE' as DLT, 'SELECT' as SLT, 'UPSERT'as UPSRT, 'ALTER TABLE' as AT, 'CREATE TABLE' as CT, 'TRUNCATE TABLE' as TT, 'DROP TABLE' as DT, 'PL/SQL EXECUTE' as PLSQL, 'REVOKE OBJECT' as REV, 'ALTER DATABASE' as AD, 'EXPLAIN' as EP)
          )
ORDER BY  day_hour;

SELECT    *
FROM      (
          SELECT    username, TO_CHAR(sample_time, 'DDMMRRHH24MI') "DAY_HOUR", sql_opname
          FROM      dba_hist_active_sess_history ash, dba_users du
          WHERE     ash.user_id = du.user_id
          AND       snap_id BETWEEN &&begin_snap AND &&end_snap
          )
PIVOT     (
          COUNT(sql_opname)
          FOR sql_opname IN ('INSERT' as INSRT, 'UPDATE' as UPD, 'DELETE' as DLT, 'SELECT' as SLT, 'UPSERT'as UPSRT, 'ALTER TABLE' as AT, 'CREATE TABLE' as CT, 'TRUNCATE TABLE' as TT, 'DROP TABLE' as DT, 'PL/SQL EXECUTE' as PLSQL, 'REVOKE OBJECT' as REV, 'ALTER DATABASE' as AD, 'EXPLAIN' as EP)
          )
ORDER BY  username, day_hour;

SELECT    username, sql_id, sql_child_number, COUNT(*) CNT
FROM      v$active_session_history ash, dba_users du
WHERE     ash.user_id = du.user_id
AND       sample_time > TO_DATE('&&start_datetime','DDMMRRHH24MI')
AND       sample_time < TO_DATE('&&end_datetime','DDMMRRHH24MI')
AND       ash.user_id > 0
AND       sql_opname = '&sql_opname'
GROUP BY  username, sql_id, sql_child_number
HAVING    COUNT(*) > 1
ORDER BY  4;

SELECT    username, sql_id, sql_child_number, COUNT(*) CNT
FROM      dba_hist_active_sess_history ash, dba_users du
WHERE     ash.user_id = du.user_id
AND       snap_id BETWEEN &&begin_snap AND &&end_snap
AND       ash.user_id > 0
AND       sql_opname = '&sql_opname'
GROUP BY  username, sql_id, sql_child_number
HAVING    COUNT(*) > 1
ORDER BY  4;
