SELECT  opname,
        ROUND(sofar*8/1024/1024,2) "Completed[GB]",
        ROUND(totalwork*8/1024/1024,2) "TotalWork[GB]",
        ROUND((sofar*100)/totalwork,2) "%Completed",
        TO_CHAR(TRUNC(elapsed_seconds/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD(elapsed_seconds,3600)/60),'FM00') || ':' || TO_CHAR(MOD(elapsed_seconds,60),'FM00') "Time Completed",
        TO_CHAR(TRUNC(time_remaining/3600),'FM9900') || ':' || TO_CHAR(TRUNC(MOD(time_remaining,3600)/60),'FM00') || ':' || TO_CHAR(MOD(time_remaining,60),'FM00') "Time Remaining"
FROM    v$session_longops
WHERE   sofar <> totalwork
AND     totalwork <> 0
/
