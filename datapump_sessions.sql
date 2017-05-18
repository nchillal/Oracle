SET LINESIZE 150 PAGESIZE 100 NUMWIDTH 7
COLUMN program FORMAT a38
COLUMN username FORMAT a10
COLUMN spid FORMAT a7
SELECT    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') "DATE",
          s.program,
          s.sid,
          s.status,
          s.username,
          d.job_name,
          p.spid,
          s.serial#,
          p.pid
FROM      v$session s, v$process p, dba_datapump_sessions d
WHERE     p.addr=s.paddr
AND       s.saddr=d.saddr;
