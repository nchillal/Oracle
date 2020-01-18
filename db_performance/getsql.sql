SET PAGESIZE 2000 LINESIZE 260

BREAK ON username SKIP 1
COLUMN username FORMAT a15
COLUMN event FORMAT a45
COLUMN module FORMAT a30
COLUMN client_info FORMAT a50
COLUMN "sid, serial#" FORMAT a15
COLUMN sql_text FORMAT a140

SELECT    s.sid||','||s.serial# "sid, serial#", s.username, s.module, s.client_info, s.event, p.sql_id, s.sql_child_number, s.sql_hash_value, p.plan_hash_value
FROM      v$session s, v$sqlarea p
WHERE     s.sql_hash_value = p.hash_value
AND       s.sql_address = p.address
AND       status='ACTIVE'
AND       type <> 'BACKGROUND';

SELECT    DBMS_LOB.SUBSTR(sql_text, 5000, 1) sql_fulltext
FROM      gv$sqltext
WHERE     sql_id = '&sql_id'
ORDER  BY piece;

SELECT    inst_id, sid, username, sql_id, sql_exec_id, module, status,
          TRUNC(SYSDATE - ADD_MONTHS(sql_exec_start, MONTHS_BETWEEN(SYSDATE, sql_exec_start))) "DAYS",
          TRUNC(24*MOD(SYSDATE - sql_exec_start, 1)) "HOURS",
          TRUNC(MOD(MOD(SYSDATE - sql_exec_start,1)*24,1)*60 ) "MINUTES",
          MOD(MOD(MOD(SYSDATE - sql_exec_start, 1)*24,1)*60,1)*60 "SECONDS",
          sql_plan_hash_value, elapsed_time  buffer_gets, disk_reads
FROM      gv$sql_monitor
WHERE     sid IN (SELECT sid FROM gv$session WHERE status='ACTIVE')
AND       status = 'EXECUTING';

SELECT   inst_id,
        sid||','||serial# "sid, serial#",
        username,
        sql_id,
        sql_exec_id,
        event,
        SYSDATE,
        sql_exec_start,
        TRUNC(SYSDATE - ADD_MONTHS(sql_exec_start, MONTHS_BETWEEN(SYSDATE, sql_exec_start))) "DAYS",
        TRUNC(24 * MOD(SYSDATE - sql_exec_start, 1)) "HOURS",
        TRUNC(MOD(MOD(SYSDATE - sql_exec_start, 1) * 24, 1) *60) "MINUTES",
        MOD(MOD(MOD(SYSDATE - sql_exec_start, 1) * 24, 1) * 60, 1) * 60 "SECONDS"
FROM    gv$session
WHERE     status = 'ACTIVE' AND type <> 'BACKGROUND' AND username <> 'SYS';
