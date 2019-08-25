SET linesize 200
SET colsep |

SELECT  ROUND(sofar*8/1024/1024,2) "Completed[GB]",
        ROUND(totalwork*8/1024/1024,2) "TotalWork[GB]",
        ROUND((sofar*100)/totalwork,2) "%Completed",
        TO_CHAR(TRUNC(elapsed_seconds/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD(elapsed_seconds,3600)/60),'FM00') || ':' || TO_CHAR(MOD(elapsed_seconds,60),'FM00') "Time Completed", 
        TO_CHAR(TRUNC(time_remaining/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD(time_remaining,3600)/60),'FM00') || ':' || TO_CHAR(MOD(time_remaining,60),'FM00') "Time Remaining"
FROM    v$session_longops
WHERE   UPPER(opname) LIKE '%RMAN%'
AND     sofar <> totalwork
AND     totalwork <> 0
AND     opname='RMAN: aggregate input';

COLUMN client_info FORMAT a30
COLUMN event FORMAT a40

SELECT  sid,
        spid,
        client_info,
        event,
        seconds_in_wait,
        p1,
        p2,
        p3
FROM    v$process p,
        v$session s
WHERE   p.addr = s.paddr
AND     client_info LIKE 'rman channel=%';